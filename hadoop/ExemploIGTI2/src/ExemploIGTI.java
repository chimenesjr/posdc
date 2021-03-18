
package IGTI;

import java.io.*;
import java.util.*;
import java.util.Random;
import java.text.*;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.fs.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapred.*;
import org.apache.hadoop.util.*;


public class ExemploIGTI extends Configured implements Tool 
{          
    public static void main (final String[] args) throws Exception {   
      int res = ToolRunner.run(new Configuration(), new ExemploIGTI(), args);        
      System.exit(res);           
    }   

    public int run (final String[] args) throws Exception {
      try{ 	             	       	
            JobConf conf = new JobConf(getConf(), ExemploIGTI.class);			
            conf.setJobName("Exemplo IGTI - Media");            
               
            final FileSystem fs = FileSystem.get(conf); 
            Path diretorioEntrada = new Path("Entrada" + UUID.randomUUID().toString()), diretorioSaida = new Path("Saida" + UUID.randomUUID().toString());

            /* Criar um diretorio de entrada no HDFS */
            if (!fs.exists(diretorioEntrada))
                fs.mkdirs(diretorioEntrada);

            /* Adicionar um arquivo para ser processado */
            fs.copyFromLocalFile(new Path("/usr/local/hadoop/Dados/arquivoBigData.txt"), diretorioEntrada);             

            /* Atribuindo os diretorios de Entrada e Saida para o Job */
            FileInputFormat.setInputPaths(conf,  diretorioEntrada); 
            FileOutputFormat.setOutputPath(conf, diretorioSaida);
  
            conf.setOutputKeyClass(Text.class);     
            conf.setOutputValueClass(Text.class);   
            conf.setMapperClass(MapIGTI.class);
            conf.setReducerClass(ReduceIGTI.class);
            JobClient.runJob(conf);   
                                
        }
        catch ( Exception e ) {
            throw e;
        }
        return 0;
    }

    public static class MapIGTI extends MapReduceBase implements Mapper<LongWritable, Text, Text, Text> {
      
      public void map(LongWritable key, Text value, OutputCollector<Text, Text> output, Reporter reporter)  throws IOException {

        Text txtChave = new Text();
        Text txtValor = new Text();

        String codigoCliente = value.toString().substring(58, 61);
        String qtdeItens = value.toString().substring(76, 84);

        txtChave.set(codigoCliente);
        txtValor.set(qtdeItens);                       

        output.collect(txtChave, txtValor);            

      }
    }


    public static class ReduceIGTI extends MapReduceBase implements Reducer<Text, Text, Text, Text> {       
      
      public void reduce (Text key, Iterator<Text> values, OutputCollector<Text, Text> output, Reporter reporter) throws IOException {                                                                                 double media = 0.0; 
            
            double maior = 0.0;
            Text value = new Text();

            while (values.hasNext()) {
              
              value = values.next();
              double current = Double.parseDouble(value.toString());
              
              if (current > maior)
                maior = current;

            }

            value.set(String.valueOf(maior));
            output.collect(key, value);
      }            
    
    }
}

/*

test inside

  docker exec hadoop mkdir /usr/local/hadoop/examples/ExemploIGTI2
  docker exec hadoop ls -l /usr/local/hadoop/examples/ExemploIGTI2
  cd /usr/local && git clone https://github.com/chimenesjr/posdc.git && cd posdc

  docker cp /usr/local/posdc/hadoop/ExemploIGTI2/. hadoop:/usr/local/hadoop/examples/ExemploIGTI2
  docker exec hadoop ant -f /usr/local/hadoop/examples/ExemploIGTI2/build_ExemploIGTI.xml makejar
  docker exec hadoop ./usr/local/hadoop/bin/hadoop jar /usr/local/hadoop-2.7.1/examples/ExemploIGTI2/ExemploIGTI.jar IGTI.ExemploIGTI
  docker exec hadoop /usr/local/hadoop/bin/hdfs dfs -ls /user/root
  docker exec hadoop /usr/local/hadoop/bin/hdfs dfs -cat /user/root/Saida8914c34f-e09a-463f-9834-82bc1b0783ff/part-00000

*/



