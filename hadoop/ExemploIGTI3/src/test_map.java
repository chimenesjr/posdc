import java.io.*;
import java.util.*;
import java.util.Random;
import java.text.*;

public class test_map {
    
    public static void main(String[] args) {  
        System.out.println("Hello World!");        
        
        Mapping mapping = new Mapping();

        mapping.map("x", "u", new OutputCollector<Text, Text>());
    }   
}