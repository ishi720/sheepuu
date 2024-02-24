import ddf.minim.*;  // 音を扱うライブラリ

Minim minim;
AudioPlayer bgm;
AudioSnippet sound;

PImage[] s = new PImage[12];
PImage bg1, bg2, bg3, bg4;//背景
PImage Sheep1, Sheep2, Sheep3;
int s_flag;//シーンフラグ
int m_flag;//クリックフラグ
int ja_flag;//ジャンプフラグ
int S_size=150;//羊のサイズ
float SheepX, SheepY;//羊の位置
int count;//カウント
int bad_count;//バッドカウント
int times=30;
int x, y;

void setup() {
  size(320, 320);//画面サイズ
  frameRate(60);

  bg1=loadImage("background1.png");
  bg2=loadImage("background2.png");
  bg3=loadImage("background3.png");
  bg4=loadImage("background4.png");
  Sheep1=loadImage("Sheep1.png");
  Sheep2=loadImage("Sheep2.png");
  Sheep3=loadImage("Sheep3.png");

  s[0]=loadImage("0.png");
  s[1]=loadImage("1.png");
  s[2]=loadImage("2.png");
  s[3]=loadImage("3.png");
  s[4]=loadImage("4.png");
  s[5]=loadImage("5.png");
  s[6]=loadImage("6.png");
  s[7]=loadImage("7.png");
  s[8]=loadImage("8.png");
  s[9]=loadImage("9.png");
  s[10]=loadImage("10.png");
  s[11]=loadImage("11.png");

  minim = new Minim(this);  // 初期化
  bgm = minim.loadFile("nmb008_64.mp3");   // BGM(再生ファイル)の指定
  sound = minim.loadSnippet("sheep.aif");  // 効果音(再生ファイル)の指定
  bgm.loop();  // BGMをループ再生

  s_flag=0;
  m_flag=0;
  ja_flag=0;

  SheepX=-50;
  SheepY=125;

  PFont font = createFont("MS Gothic", 48);
  textFont(font);
  count=0;
  bad_count=0;
}

void draw() {

  if (s_flag==0) {//スタート画面
    background(bg1);

  } else if (s_flag==1) {//プレイ画面
    background(bg2);
    fill(255, 0, 0);

    if (bad_count<=0) {
      image(s[11], 0, -10, 130, 130);
    }
    if (bad_count<=1) {
      image(s[11], 50, -10, 130, 130);
    }
    if (bad_count<=2) {
      image(s[11], 100, -10, 130, 130);
    }

    image(s[10], 280, 10, 50, 50);//匹
    image(s[count%10], 240, 10, 50, 50);
    if (count/10>=1) {
      image(s[(count/10)%10], 210, 10, 50, 50);
    }
    if (count/100>=1) {
      image(s[(count/100)%10], 180, 10, 50, 50);
    }
    if (count>=1000) {
      s_flag=2;
    }

    SheepX += 0.5;
    if (SheepX>=width || SheepY>=height) {//画面外ループ
      SheepX=-100;
      SheepY=125;
      ja_flag=0;
      m_flag=0;
    }

    if (ja_flag==0 && SheepX<60 && m_flag==1) {
      ja_flag=1;
    }

    if (ja_flag==0 && SheepX<=80) {//歩行
      image(Sheep1, SheepX-10, SheepY, S_size, S_size);
    }
    if (ja_flag==0 &&  SheepX>=80) {//落下
      image(Sheep2, SheepX, SheepY, S_size, S_size);//上昇
      SheepY+=2;
      if (SheepY>=height) {
        bad_count+=1;
      }
    }

    if (ja_flag==1) {//ジャンプ上昇
      if (SheepX>=30) {//もし崖より右
        image(Sheep2, SheepX, SheepY, S_size, S_size);//上昇
        SheepY-=1;
        if (SheepY<=60) {//昇り切ったら
          ja_flag=2;//下降へ
          count+=1;
          bad_count=0;
        }
      } else {
        image(Sheep1, SheepX-10, SheepY, S_size, S_size);
      }
    }

    if (ja_flag==2) {//ジャンプ下降
      image(Sheep3, SheepX+30, SheepY, S_size, S_size);
      SheepY+=1;
      if (SheepY>=125) {
        ja_flag=3;
      }
    }
    if (ja_flag==3) {
      image(Sheep1, SheepX+20, SheepY, S_size, S_size);//歩行
      m_flag=0;
    }
    if (bad_count==3) {
      s_flag=2;
    }
  } else if (s_flag==2) {//おやすみ画面
    background(bg3);
    times++;
    if (round(times/frameRate)==3) {
      exit();
    }
  } else if (s_flag==3) {
    background(bg4);
    if (m_flag==2) {
      s_flag=4;
    }
  } else if (s_flag==4) {
    background(0);
  }
}

void mousePressed() {
  if (s_flag==0 &&  mouseX>=30 && mouseX<=80 && mouseY>=200 && mouseY<=250) {
    m_flag=1;
  }

  if (s_flag==0 &&  mouseX>=230 && mouseX<=280 && mouseY>=200 && mouseY<=250) {
    m_flag=3;
  }

  if (s_flag==1) {
    m_flag=1;
  }
}

void mouseReleased() {
  sound.rewind();  // 効果音の頭出し
  sound.play();    // 効果音再生
  m_flag=2;
  s_flag=1;
}
