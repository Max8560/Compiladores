import java.io.*;
import java.util.regex.*; 

class AFN {
    private int ini, cantfin;
    private int fin[] = new int[5];
    private int automata[][] = new int [10][3];

    public void cargar_desde(String nombre){
        File archivo = null;
        FileReader fr = null;
        String aux = "", auxant = "";
        int x=0, y=0, revisa=0;

        try {
            archivo = new File (nombre);
            fr = new FileReader (archivo);
            int caract = fr.read();
            //Se lee caracter por caracter
            while(caract != -1) {
                cantfin = 0;
                aux += (char)caract;

                //Para obtener el Autómata
                if(revisa == 2) {

                    //De donde viene
                    if((char)caract == '-'){
                        aux = str.replace("-","");
                        automata[x][y] = Integer.parseInt(aux);
                    }

                    //A donde va

                    //Con que se mueve

                }

                //Para obtener el nodo inicial
                if(aux.equals("inicial:")){
                    aux = "";
                    while((char)caract != '\n'){
                        caract = fr.read();
                        aux += (char)caract;
                    }
                    ini = Integer.parseInt(aux.trim());
                    aux = "";
                    revisa = 1;
                }

                //Para obtener los nodos finales
                if(aux.equals("finales:")){
                    x = 0;
                    aux = "";
                    while((char)caract != '\n'){
                        caract = fr.read();
                        aux += (char)caract;
                        if((char)caract == ',' || (char)caract == '\n'){
                            fin[x] = Integer.parseInt(aux.trim());
                            x++;
                        }
                    }
                    cantfin++;
                    aux = "";
                    revisa = 2;
                }

                caract = fr.read();
            }
        }
        catch (FileNotFoundException e) {
            System.out.println("Error: Fichero no encontrado");
            System.out.println(e.getMessage());
        }
        catch (Exception e) {
            System.out.println("Error de lectura del fichero");
            System.out.println(e.getMessage());
        }
        finally {
            try {
                if(fr != null)
                    fr.close();
            }
            catch (Exception e) {
                System.out.println("Error al cerrar el fichero");
                System.out.println(e.getMessage());
            }
        }
    }
  
    public static void main(String[] args) throws IOException{
        AFN a = new AFN();
        a.cargar_desde("C:/Users/ASUS X412FA/Desktop/ESCOM/Compiladores/Prac1/Auto1.af");
        System.out.println("Inicial: " + a.ini);
        System.out.println("Finales: " + a.fin[0]);
        System.out.println(a.automata[0][0] + "->" + a.automata[0][1] + "," + a.automata[0][2]);
    }
}