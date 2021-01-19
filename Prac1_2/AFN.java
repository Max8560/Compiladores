import java.io.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.sql.rowset.spi.TransactionalWriter;

public class AFN {
    public int ini;
    public int fin[] = new int[5];
    ArrayList<Transicion> t = new ArrayList<Transicion>();
    Transicion taux = new Transicion(0, 0, 'a');

    public cargar_desde(String nombre){
        String linea = "";
        int pos = 0;
        Pattern p = null;
        Matcher m = null;

        try {
            File archivo = new File(nombre);
            Scanner sc = new Scanner(archivo);

            while (sc.hasNextLine()) {
                linea = sc.nextLine();

                //Obtener las transiciones
                if(pos == 2){
                    p = Pattern.compile("(\\d+)\\p{Punct}{2}(\\d+)\\p{Punct}(\\D)");
                    m = p.matcher(linea);
                    m.find();
                    t.add(new Transicion(Integer.parseInt(m.group(1)), Integer.parseInt(m.group(2)), m.group(3).charAt(0)));
                }

                //Obtener el inicial
                if(pos == 1){
                    p = Pattern.compile("([a-zA-z]+):(\\d+\\s*)+");
                    m = p.matcher(linea);
                    while (m.find()){
                        fin[0] = Integer.parseInt(m.group(2));
                    }
                    pos = 2;
                }

                //Obtener los finales
                if(pos == 0){
                    p = Pattern.compile("([a-zA-z]+):(\\d+)");
                    m = p.matcher(linea);
                    while (m.find()){
                        ini = Integer.parseInt(m.group(2));
                    }
                    pos = 1;
                }

            }

            sc.close();
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }

    public agregar_transicion(int inicio, int fin, char simbolo){
        t.add(new Transicion(inicio, fin, simbolo));
    }

    public eliminar_transicion(int inicio, int fin, char simbolo){
        t.remove(new Transicion(inicio, fin, simbolo));
    }

    public obtener_inicial(){
        return ini;
    }

    public obtener_finales(){
        return fin;
    }

    public establecer_inicial(int estado){
        ini = estado;
    }

    public establecer_final(int estado){
        fin[x] = estado;
        x++;
    }

    public esAFN(){
        return true;
    }

    public esAFD(){
        return false;
    }

    public acepta(String cadena){
        char c;
        int pos = ini;
        int x = 0;
        c = cadena.charAt(x);

        for(y=0;y<t.size();y++){
            if((pos == t.get(y).inicial) && (c.equals(t.get(y).c))){
                pos = t.get(y).fin;
                x++;
                c = cadena.charAt(x);
                y = 0;
            }
        }

        if(pos == fin[0]){
            return true;
        }else{
            return false;
        }
    }

    public generar_cadena(){
        String cadena = "";
        return cadena;
    }

}