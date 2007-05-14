import ij.*;
import java.applet.Applet;

/** 
 * This applet instantiates an ImageJ frame and opens image(s) described
 * by applet parameters.
 * startAnimationN starts cine mode for image stack N.  runBenchmarkN
 * does the "Run Benchmark" option of ImageJ.
 *
 * Sample html to call this applet (omitted params are false):
 * <applet code="IJAppletTP.class" archive="ij.jar" width=0 height=0>
 * <param name=nImages value=2>
 * <param name=image1 value="bwhtest.jpg">
 * <param name=startAnimation1 value=false>
 * <param name=runBenchmark1 value=false>
 * <param name=image2 value="smpte.jpg">
 * <param name=startAnimation2 value=false>
 * <param name=runBenchmark2 value=false>
 * <param name=adjustBrightnessContrast value=true>
 * </applet>
 *
 * Alternately, the nImages parameter may be omitted and the following
 *   image parameters may be subsituted:
 * <param name=image value="Bridget.jpg">
 * <param name=startAnimation value=false>
 * <param name=runBenchmark value=false>
 *
 * @author J. Anthony Parker, MD PhD <J.A.Parker@IEEE.org>
 * @version 23May2002
 */
public class IJAppletTP extends Applet  {

	/** Starts ImageJ if it's not already running and displays
	images whose names are passed as parameters. */
	public void init() {
		// Start ImageJ if not already running.
		ImageJ ij = IJ.getInstance();
		if (ij==null || !ij.isShowing())
			ij = new ImageJ(this);
		ij.toFront();
		if(isTrue("adjustBrightnessContrast", "false"))
			IJ.run("Brightness/Contrast...");
		int nImg = intValue("nImages", 0);
		if(nImg <= 0)
			displayImage("");	// single image
		else {
			for(int n=1; n<=nImg; n++)
				displayImage(Integer.toString(n));
		}
		return;
	}

	protected boolean isTrue(String name, String dflt) {
		String value = getParameter(name);
		if(value == null || value == "")
			value = dflt;
		String s = value.toLowerCase().trim();
		if(s.indexOf("true")>=0 || s.indexOf("yes")>=0)
			return true;
		else
			return false;
	}

	protected int intValue(String name, int dflt) {
		try {
			return Integer.parseInt(getParameter(name));
		} catch (NumberFormatException e) {
			return dflt;
		}
	}

	protected void displayImage(String n) {
		String fileName = getParameter("image"+n);
		if(fileName==null || fileName=="") {
			IJ.runPlugIn("ij.plugin.URLOpener", "Bridget.jpg");
			return;
		} else
			IJ.runPlugIn("ij.plugin.URLOpener",fileName);
		ImagePlus imp = WindowManager.getCurrentImage();
		if(imp == null)
			return;
		String s = fileName.substring(0,fileName.indexOf('.'));
		if(imp.getTitle().indexOf(s) <0 )
			return;		// open failed or was canceled
		if(isTrue("startAnimation"+n,"false"))
			IJ.doCommand("Start Animation [=]");
		if(isTrue("runBenchmark"+n,"false"))
			IJ.run("Run Benchmark");
		return;
	}

	/** Provides information about parameters to other classes. */
	public String[][] getParameterInfo() {
		String[][] info = {
			// Parameter Name, Kind of Value, Description
			{"nImages", "int", "N, the number of images"},
			{"image", "fileName", "defualt image"},
			{"startAnimation", "boolean", "animate stack"},
			{"runBenchmark", "boolean", "run benchmark"},
			{"imageX", "fileName", "image X"},
			{"startAnimationN", "boolean", "animate stack N"},
			{"runBenchmarkN", "boolean", "run benchmark on N"},
			{"adjustBrightnessContrast", "boolean", "B/C window"}
		};
		return info;
	}

}