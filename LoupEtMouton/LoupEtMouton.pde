//Pour sauvegarder les données : garder appuyer espace, puis cliquer

//Simulation
float lh;
int dir[][] = {{-1, 0}, {1, 0}, {0, 1}, {0, -1}};
boolean touches[] = new boolean[255];

//Herbe
int nHerbe = 100;
boolean herbes[][] = new boolean[nHerbe][nHerbe];
float energieHerbe = 10;
float prcHerbe = 0.1;
float prcReproHerbe = 0.01;
float prcAppHerbe = 0.0001;

//Moutons
int nMout = 20;
ArrayList<mouton> mout = new ArrayList<mouton>();

//Resultats
IntList nH = new IntList();
IntList nM = new IntList();


void setup() {
  size(700, 700);
  for (int i = 0; i < nHerbe; i ++) {
    for (int j = 0; j < nHerbe; j ++) {
      float r = random(0, 1);
      if (r < prcHerbe) {
        herbes[i][j] = true;
      }
    }
  }
  lh = float(width/nHerbe);
  for (int i = 0; i < nMout; i ++) {
    mout.add(new mouton());
  }
}


void draw() {
  background(0);
  affichageHerbe();
  affichageMouton();
}


void keyPressed(){
  touches[keyCode] = true;
}


void keyReleased(){
  touches[keyCode] = false;
}


void mouseClicked(){
  if(touches[32]){
    String[] res = new String[nH.size()];
    for(int i = 0; i < nH.size() ; i ++){
      res[i] = str(i)+" "+str(nH.get(i))+" "+str(nM.get(i));
    }
    saveStrings("resultats.txt",res);
    println("save");
  }
}


void affichageHerbe() {
  int nhh = 0;
  pushStyle();
  //noStroke();
  stroke(80, 220, 70);
  fill(80, 220, 70);
  for (int i = 0; i < nHerbe; i ++) {
    for (int j = 0; j < nHerbe; j ++) {
      if (herbes[i][j]) {
        nhh ++;
        rect(i*lh, j*lh, lh, lh);
      }else{
        float r = random(0, 1);
        if(r < prcAppHerbe){
          herbes[i][j] = true;
        }
      }
      float r = random(0, 1);
      if (r < prcReproHerbe && herbes[i][j]) {
        IntList np = new IntList();
        int dirp[][] = new int[4][2];
        for (int k = 0; k < 4; k ++) {
          if (i+dir[k][0] > 0 && i+dir[k][0] < nHerbe && j+dir[k][1] > 0 && j+dir[k][1] < nHerbe) {
            if (herbes[i+dir[k][0]][j+dir[k][1]] == false) {
              dirp[k] = dir[k];
              np.append(k);
            } else {
              dirp[k][0] = -1;
              dirp[k][1] = -1;
            }
          } else {
            dirp[k][0] = -1;
            dirp[k][1] = -1;
          }
        }
        if(np.size() > 0){
          int rp = int(random(0,np.size()));
          int num = np.get(rp);
          herbes[i+dir[num][0]][j+dir[num][1]] = true;
        }
        
      }
    }
  }

  popStyle();
  nH.append(nhh);
}


void affichageMouton() {
  for (int i = 0; i < mout.size(); i ++) {
    mouton mouti = mout.get(i);
    mouti.deplaff();
    if (mouti.energie <= 0) {
      mout.remove(i);
    }
  }
  nM.append(mout.size());
}


class mouton {
  float xm, ym;
  float xc, yc;
  float ac;
  float vm = lh/2;
  int ih, jh;
  boolean cible = false;
  float energie = 20;
  float energieMax = sqrt(2)*nHerbe*2;

  mouton() {
    xm = random(0, width);
    ym = random(0, height);
    selectCible();
  }

  void selectCible() {
    float dmin = -1;
    boolean trouver = false;
    for (int i = 0; i < nHerbe; i ++) {
      for (int j = 0; j < nHerbe; j ++) {
        if (herbes[i][j]) {
          if (dmin < 0) {
            float tc = (xm-i*lh)*(xm-i*lh) + (ym-j*lh)*(ym-j*lh);
            dmin = tc;
            xc = (i+0.5)*lh;
            yc = (j+0.5)*lh;
            ih = i;
            jh = j;
            trouver = true;
          } else {
            float tc = (xm-i*lh)*(xm-i*lh) + (ym-j*lh)*(ym-j*lh);
            if (tc < dmin) {
              dmin = tc;
              xc = (i+0.5)*lh;
              yc = (j+0.5)*lh;
              ih = i;
              jh = j;
              trouver = true;
            }
          }
        }
      }
    }
    if (trouver == false) {
      cible = false;
    } else {
      cible = true;
    }
    ac = atan2(yc-ym, xc-xm);
  }

  void deplaff() {
    if (cible && herbes[ih][jh]) {
      xm += cos(ac)*vm;
      ym += sin(ac)*vm;
      energie -= 1;
      if ((xm-xc)*(xm-xc) + (ym-yc)*(ym-yc) < vm*vm*1.1) {
        herbes[ih][jh] = false;
        selectCible();

        if (energie < energieMax) {
          energie += energieHerbe;
        }else{
          mout.add(new mouton());
          energie /= 2;
        }
      }
    } else {
      selectCible();
    }
    pushStyle();
    stroke(250);
    fill(250);
    rect(xm-lh/2, ym-lh/2, lh, lh);
    popStyle();
    energie -= 0.5;
  }
}
