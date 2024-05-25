// Un sistema de particules necessita estructura
// Una bona manera d'estructurar es tenir objectes
// Els objectes es creen amb classes
// Una particula pot ser un objecte! i moltes tb


//Afegirem comportaments de boids (vida artificial)
//En posarem 2 amb 2 heuristiques de moviment (intencions)
//Una de seguir a un lider i una altre d'anar a un desti
//Aquestes intencions faran de forces

// Variables i objectes
float increment_temps = 0.4;
PVector desti;
particula boid1;
particula boid2;
particula lider;
// Funcions i classes
class particula {
  // Atributs
  PVector posicio_particula;
  PVector velocitat_particula;
  PVector acceleracio_particula;
  boolean soc_lider;
  float massa_particula;
  float tamany_particula;
  float constant_desti, constant_lider, constant_friccio;
  color color_particula;
  // Constructor
  particula(boolean l, PVector p, PVector v, float m, float tam, float const_d, float const_l, float const_f, color c) {
    posicio_particula = new PVector(0.0,0.0,0.0);
    velocitat_particula = new PVector(0.0,0.0,0.0);
    acceleracio_particula = new PVector(0.0,0.0,0.0);
    
    posicio_particula.set(p);
    velocitat_particula.set(v);
    
    massa_particula = m;
    tamany_particula = tam;
    color_particula = c;
    
    constant_desti = const_d;
    constant_lider = const_l;
    constant_friccio = const_f;
    soc_lider = l;
  }
  // Metodes
  void calcula_particula(){
    PVector acumulador_forsa;
    PVector vector_per_usar;
    acumulador_forsa = new PVector(0.0,0.0,0.0);
    vector_per_usar = new PVector(0.0,0.0,0.0);
    // Solver Euler
    // 0) Acumular les forces
    //Forca cap al desti
    //Calculem el vector que va del boid al desti
    vector_per_usar.x = desti.x - posicio_particula.x;
    vector_per_usar.y = desti.y - posicio_particula.y;
    vector_per_usar.z = desti.z - posicio_particula.z;
    //Calculem el modul del vector
    float modul = sqrt(vector_per_usar.x*vector_per_usar.x+vector_per_usar.y*vector_per_usar.y+vector_per_usar.z*vector_per_usar.z);
    //Fem el vector unitari dividint-lo pel modul
    vector_per_usar.x /= modul;
    vector_per_usar.y /= modul;
    vector_per_usar.z /= modul;
    //Multipliquem el vector per la seva constant associada
    vector_per_usar.x *= constant_desti;
    vector_per_usar.y *= constant_desti;
    vector_per_usar.z *= constant_desti;
    //Ara el vector ja es la forca que necessitem per anar al desti
    acumulador_forsa.x = vector_per_usar.x;
    acumulador_forsa.y = vector_per_usar.y;
    acumulador_forsa.z = vector_per_usar.z;
    

    //Forca cap el lider
    if(!soc_lider){
    //Calculo el vector que va del boid al lider
    vector_per_usar.x = lider.posicio_particula.x - posicio_particula.x;
    vector_per_usar.y = lider.posicio_particula.y - posicio_particula.y;
    vector_per_usar.z = lider.posicio_particula.z - posicio_particula.z;
    //Calculo el modul d'aquest vector
    modul = sqrt(vector_per_usar.x*vector_per_usar.x+vector_per_usar.y*vector_per_usar.y+vector_per_usar.z*vector_per_usar.z);
    //Faig unitari el vector dividint-lo pel seu modul
    vector_per_usar.x /= modul;
    vector_per_usar.y /= modul;
    vector_per_usar.z /= modul;
    //Multiplico al vector per la constant i ja tindre la força lider
    vector_per_usar.x *= constant_lider;
    vector_per_usar.y *= constant_lider;
    vector_per_usar.z *= constant_lider;
    //Acumulo (afegeixo aquesta força a les altres que hi ha
    acumulador_forsa.x += vector_per_usar.x;
    acumulador_forsa.y += vector_per_usar.y;
    acumulador_forsa.z += vector_per_usar.z;
  }
    //Forca de friccio
    acumulador_forsa.x += -1.0*constant_friccio*velocitat_particula.x;
    acumulador_forsa.y += -1.0*constant_friccio*velocitat_particula.y;
    acumulador_forsa.z += -1.0*constant_friccio*velocitat_particula.z;

    // 1) Acceleracio
    acceleracio_particula.x = acumulador_forsa.x / massa_particula;
    acceleracio_particula.y = acumulador_forsa.y / massa_particula;
    acceleracio_particula.z = acumulador_forsa.z / massa_particula;
    // 2) Velocitat
    velocitat_particula.x = velocitat_particula.x
    + acceleracio_particula.x * increment_temps;
    velocitat_particula.y = velocitat_particula.y
    + acceleracio_particula.y * increment_temps;
    velocitat_particula.z = velocitat_particula.z
    + acceleracio_particula.z * increment_temps;
    // 3) Posicio
    posicio_particula.x = posicio_particula.x
    + velocitat_particula.x * increment_temps;
    posicio_particula.y = posicio_particula.y
    + velocitat_particula.y * increment_temps;
    posicio_particula.z = posicio_particula.z
    + velocitat_particula.z * increment_temps;
  }
  
  void pinta_particula(){
    fill(color_particula);
    pushMatrix();
    translate(posicio_particula.x,posicio_particula.y,posicio_particula.z);
    noStroke();
    lights();
    sphere(tamany_particula);
    popMatrix();
  }
}

// Setup
void setup(){
  fullScreen(P3D);
  //Inicialitzo el desti
  desti = new PVector(200.0,50.0,0.0);
  // Inicialitzo les particules
  // Constructor = PVector p, PVector v, float m, float tam, color c
  boid1 = new particula(false, new PVector(width/4.0,3*height/4.0,0.0),
  new PVector(0.0,0.0,0.0),1.0,30.0,0.2,0.8, 0.5, color(255,0,0)); // KD = 0.2
  boid2 = new particula(false, new PVector(3.0*width/4.0,3*height/4.0,0.0),
  new PVector(0.0,0.0,0.0),1.0,30.0,0.8,0.1, 0.2, color(0,255,0)); // KD = 0.8
  // Lider PENDENT
  lider = new particula(true, new PVector(width/2.0,height-30.0,0.0),
  new PVector(0.0,0.0,0.0),1.0,45.0,0.9,0.0, 0.08, color(0,0,255)); // KD = 0.8
}
// Draw
void draw(){
  background(0);
  pushMatrix();
  fill(255,255,0);
  stroke(255);
  translate(width/2,(height/2)-50);
  noFill();
  box(1200, 670, 500);
  popMatrix();
  // Calcular
  boid1.calcula_particula();
  boid2.calcula_particula();
  lider.calcula_particula();
  // Pintar
  boid1.pinta_particula();
  boid2.pinta_particula();
  lider.pinta_particula();
  //Pintar desti
  pushMatrix();
  fill(255,255,0);
  stroke(255);
  translate(desti.x,desti.y,desti.z);
  noStroke();
  lights();
  box(30.0);
  popMatrix();
  
  rectMode(CENTER);
  fill(255);
  rect(width/2, height-75,1640, 150);
  fill(0);
  rect(width -400,height-105, 50,50); //1
  rect(width -400,height-45, 50,50);  //3
  
  rect(width -340,height-105, 50,50);  //2
  rect(width -340,height-45, 50,50);  //4
  
  rect(width -250,height-105, 50,50); //5
  rect(width -250,height-45, 50,50);  //7
  
  rect(width -190,height-105, 50,50);  //6
  rect(width -190,height-45, 50,50);  //8
  
    
}

void mousePressed(){
  if(mouseX > width-425 && mouseX < width -375 && mouseY > height-130 && mouseY < height-80)
  {
    desti.x = 200.0;
    desti.y = 50.0;
    desti.z = 0.0;
  }
  else if(mouseX > width-365 && mouseX < width -315 && mouseY > height-130 && mouseY < height-80)
  {
    desti.x = width -200.0;
    desti.y = 50.0;
    desti.z = 0.0;
  }
  else if(mouseX > width-425 && mouseX < width -375 && mouseY > height-70 && mouseY < height-20)
  {
    desti.x = 200.0;
    desti.y = height -200.0;
    desti.z = 0.0;
  }
  else if(mouseX > width-365 && mouseX < width -315 && mouseY > height-70 && mouseY < height-20)
  {
    desti.x = width -200.0;
    desti.y = height -200.0;
    desti.z = 0.0;
  }
  //--------------------------------------------------------------------------------------------
  if(mouseX > width-275 && mouseX < width -225 && mouseY > height-130 && mouseY < height-80)
  {
    desti.x = 200.0;
    desti.y = 50.0;
    desti.z = -450.0;
  }
  else if(mouseX > width-215 && mouseX < width -65 && mouseY > height-130 && mouseY < height-80)
  {
    desti.x = width -200.0;
    desti.y = 50.0;
    desti.z = -450.0;
  }
  else if(mouseX > width-275 && mouseX < width -225 && mouseY > height-70 && mouseY < height-20)
  {
    desti.x = 200.0;
    desti.y = height -200.0;
    desti.z = -450.0;
  }
  else if(mouseX > width-215 && mouseX < width -65 && mouseY > height-70 && mouseY < height-20)
  {
    desti.x = width -200.0;
    desti.y = height -200.0;
    desti.z = -450.0;
  }
}
