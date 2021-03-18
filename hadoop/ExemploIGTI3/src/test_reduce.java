public class test_reduce {
    public static void main(String[] args) {  
        System.out.println("Hello World!");        
        
        Reducing reducing = new Reducing();

        Text key = new Text();
        Text values = new Text();
        OutputCollector<Text, Text> output = new OutputCollector<Text, Text>();

        reducing.reduce(key, values, output);
    }   
}
