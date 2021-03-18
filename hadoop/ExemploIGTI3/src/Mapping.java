import java.text.SimpleDateFormat;
import java.util.Date;

public class Mapping {

    public void map(String key, String value, OutputCollector<Text, Text> output) {

        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

        System.out.println("======== START MAP ========" + formatter.format(new Date()));

        Text txtChave = new Text();
        Text txtValor = new Text();

        String codigoCliente = value.toString();//.substring(58, 61);
        String qtdeItens = value.toString();//.substring(76, 84);

        txtChave.set(codigoCliente);
        txtValor.set(qtdeItens);                       

        output.collect(txtChave, txtValor);            

        System.out.println("======== END MAP ========" + formatter.format(new Date()));
    }
}