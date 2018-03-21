import java.io.IOException;
import java.util.*;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class ngram {

  public static class TokenizerMapper
       extends Mapper<Object, Text, Text, IntWritable>{
	private Text k    = new Text("-");
	 private final static IntWritable one = new IntWritable(1);
	 private Text word = new Text();
	 public List<String> wordlist=new ArrayList();
       private String pattern="[\\pP\\pM]";
    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {                
  	 String line=value.toString();
         line=line.replaceAll(pattern," ");
      StringTokenizer itr = new StringTokenizer(line);
      while (itr.hasMoreTokens()) {
	String next=itr.nextToken();
	wordlist.add(next);
      }
}
@Override
	protected void cleanup(Context context)throws IOException,InterruptedException{
	Configuration conf=context.getConfiguration();          
        int n=Integer.valueOf(conf.get("numn"));
	 String gram=new String("");
	for(int i=0;i<wordlist.size()-n;i++)
	{
	for(int j=0;j<n;j++)
	{
	int val=i+j;
	gram=gram+wordlist.get(val)+" ";
	}
	word.set(gram);
	context.write(word,one);
	gram="";
	}
    }
  }

  public static class IntSumReducer
       extends Reducer<Text,IntWritable,Text,IntWritable> {
    private IntWritable result = new IntWritable();

    public void reduce(Text key, Iterable<IntWritable> values,
                       Context context
                       ) throws IOException, InterruptedException {
      int sum = 0;
      for (IntWritable val : values) {
        sum += val.get();
      }
      result.set(sum);
      context.write(key, result);
    }
  }

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    conf.set("numn", args[2]);
    String temp_path = "temp";

    Job job = Job.getInstance(conf, "word count");
    job.setJarByClass(ngram.class);
    job.setMapperClass(TokenizerMapper.class);
    job.setCombinerClass(IntSumReducer.class);  
    job.setReducerClass(IntSumReducer.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(IntWritable.class);
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);

  }
}
