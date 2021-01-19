public class Transicion {
    public int nodo_inicial;
    public int nodo_final;
    public char caracter;
    
    public Transicion(){
        
    }
    
    public Transicion(int i, int f, char c){
        nodo_inicial = i;
        nodo_final = f;
        caracter = c;
    }
}
