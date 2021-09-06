import java.io.File;
import java.util.Scanner;

import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.Xslt30Transformer;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;

public class Transformer {
    public static void main(String[] args) throws Exception {
        Processor processor = new Processor(false);
        XsltCompiler compiler = processor.newXsltCompiler();
        Scanner sc = new Scanner(System.in);
        boolean single = false, answered = false;
        while(!answered) {
            System.out.println("Select how to parse the file = 'single' for one page with TOC, "+
                            "'multi' for a multipage style");   
            String answer = sc.nextLine();
            switch (answer) {
                case "single":
                    single=true;
                case "multi":
                    answered=true;
                    break;
            }
        }
        sc.close();
        XsltExecutable stylesheet = null;
        Serializer out = null;
        if (single) {
            stylesheet = compiler.compile(new StreamSource(new File("styles/onepage.xsl")));
            out = processor.newSerializer(new File("output.html"));
        } else {
            stylesheet = compiler.compile(new StreamSource(new File("styles/multipage.xsl")));
            out = processor.newSerializer(new File("output/index.html"));
        }
        out.setOutputProperty(Serializer.Property.METHOD, "html");
        out.setOutputProperty(Serializer.Property.INDENT, "yes");
        Xslt30Transformer trans = stylesheet.load30();
        trans.transform(new StreamSource(new File("sources/input.xml")), out);

        if (single) {
            System.out.println("Output written to the output.html file in the project directory");
        } else {
            System.out.println("Output written to the output directory");
        }
    }
}