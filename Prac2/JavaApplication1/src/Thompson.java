import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Thompson {
    AFN aux = new AFN();
    ArrayList<AFN> auts = new ArrayList<>();
    int nodos = 0;
    int canta = 0;
    
    public Thompson(){
    }
    
    public void concat(char[] a){
        aux.inicial = nodos;
        int tam = a.length;
        
        for(int x=0;x<tam;x++){
            aux.trans.add(new Transicion(nodos,nodos+1,a[x]));
            nodos++;
        }
        aux.fin = nodos;
        auts.add(aux);
        aux = new AFN();
        
        /*System.out.println(automata.trans.get(0).nodo_inicial + "," + automata.trans.get(0).caracter + 
                " -> " + automata.trans.get(0).nodo_final);
        System.out.println(automata.trans.get(1).nodo_inicial + "," + automata.trans.get(1).caracter + 
                " -> " + automata.trans.get(1).nodo_final);*/
    }
    
    public void c_asterisco(char[] a){
        int tam = a.length;
        
        if(tam > 1){
            concat(a);
            nodos++;
            canta++;
        }
        
        aux.inicial = nodos;
        nodos++;
        aux.fin = nodos;
        
        aux.trans.add(new Transicion(auts.get(canta-1).fin,auts.get(canta-1).inicial,'E'));
        aux.trans.add(new Transicion(aux.inicial,auts.get(canta-1).inicial,'E'));
        
        for(int x=0;x<auts.get(canta-1).trans.size();x++){
            aux.trans.add(auts.get(canta-1).trans.get(x));
        }
        
        aux.trans.add(new Transicion(auts.get(canta-1).fin,aux.fin,'E'));
        aux.trans.add(new Transicion(aux.inicial,aux.fin,'E'));
        
        auts.add(aux);
        aux = new AFN();
    }
    
    public void c_positiva(char[] a){
        int tam = a.length;
        
        concat(a);
        nodos++;
        canta++;
        
        aux.inicial = nodos;
        
        nodos++;
        aux.fin = nodos;
        
        aux.trans.add(new Transicion(auts.get(canta-1).fin,auts.get(canta-1).inicial,'E'));
        aux.trans.add(new Transicion(aux.inicial,auts.get(canta-1).inicial,'E'));
        
        for(int x=0;x<auts.get(canta-1).trans.size();x++){
            aux.trans.add(auts.get(canta-1).trans.get(x));
        }
        
        aux.trans.add(new Transicion(auts.get(canta-1).fin,aux.fin,'E'));
        aux.trans.add(new Transicion(aux.inicial,aux.fin,'E'));
        nodos++;
        
        for(int x=0;x<tam-1;x++){
            aux.trans.add(new Transicion(nodos,nodos+1,a[x]));
            nodos++;
        }
        
        aux.trans.add(new Transicion(nodos,aux.inicial,a[tam-1]));
        
        auts.add(aux);
        aux = new AFN();
    }
    
    public void union(AFN a, AFN b){
        aux.trans.add(new Transicion(nodos,a.inicial,'E'));
        aux.trans.add(new Transicion(nodos,b.inicial,'E'));
        nodos++;
        
        for(int x=0;x<a.trans.size();x++){
            aux.trans.add(a.trans.get(x));
        }
        for(int x=0;x<b.trans.size();x++){
            aux.trans.add(b.trans.get(x));
        }
        
        aux.trans.add(new Transicion(a.fin,nodos,'E'));
        aux.trans.add(new Transicion(b.fin,nodos,'E'));
        nodos++;
        
        auts.add(aux);
    }
    
    public AFN convertir(String expresion_regular){
        Pattern p;
        Matcher m;
        
        
        
        //Para encontrar y procesar cerradura asterisco
        /*p = Pattern.compile("([a-z]+)\\*");
        m = p.matcher(expresion_regular);
        
        while(m.find()){
            c_asterisco(m.group(1).toCharArray());
            nodos++;
            canta++;
        }*/
        
        //Para encontrar y procesar union/or
        /*p = Pattern.compile("([a-z]+)\\|([a-z]+)");
        m = p.matcher(expresion_regular);
        
        while(m.find()){
            concat(m.group(1).toCharArray());
            nodos++;
            canta++;
            concat(m.group(2).toCharArray());
            nodos++;
            canta++;
            union(auts.get(canta-1),auts.get(canta-2));
            nodos++;
            canta++;
        }*/
        
        //Para encontrar y procesar cerradura positiva
        /*p = Pattern.compile("([a-z]+)\\+");
        m = p.matcher(expresion_regular);
        
        while(m.find()){
            c_positiva(m.group(1).toCharArray());
            nodos++;
            canta++;
        }*/
        
        //Para encontrar y procesar concatenación
        /*p = Pattern.compile("([a-z]+)");
        m = p.matcher(expresion_regular);
        
        while(m.find()){
            concat(m.group(1).toCharArray());
            nodos++;
            canta++;
        }*/
        
        for(int x=0;x<auts.size();x++){
            for(int y=0;y<auts.get(x).trans.size();y++){
                System.out.println(auts.get(x).trans.get(y).nodo_inicial + "," + auts.get(x).trans.get(y).caracter + 
                " -> " + auts.get(x).trans.get(y).nodo_final);
            }
            System.out.println();
        }
        
        return auts.get(canta-1);
    }
}
