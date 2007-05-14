import ij.*;
import java.applet.*;
import java.awt.*;
import ij.process.*;

/**Simple applet that demonstrates how to use ImageJ's ImageProcessor class.*/
public class IPDemo extends Applet {

	String name;
	Image img;
	ImageProcessor ip = null;

	public void init() {
		setLayout(new BorderLayout());
		Panel p = new Panel();
		p.setLayout(new GridLayout(5, 3));
		p.add(new Button("Reset"));
		p.add(new Button("Flip"));
		p.add(new Button("Invert"));
		p.add(new Button("Lighten"));
		p.add(new Button("Darken"));
		p.add(new Button("Rotate"));
		p.add(new Button("Zoom In"));
		p.add(new Button("Zoom Out"));
		p.add(new Button("Threshsold"));
		p.add(new Button("Smooth"));
		p.add(new Button("Sharpen"));
		p.add(new Button("Find Edges"));
		p.add(new Button("Macro 1"));
		p.add(new Button("Macro 2"));
		p.add(new Button("Add Noise"));
		add("South", p);
		name = getParameter("img");
		img = getImage(getDocumentBase(), name);
		MediaTracker tracker = new MediaTracker(this);
		tracker.addImage(img, 0);
		try {tracker.waitForID(0);}
		catch (InterruptedException e){}
		if (name.endsWith("jpg"))
			ip = new ColorProcessor(img);
		else
			ip = new ByteProcessor(img);
		ip.snapshot();
	}


	public void update(Graphics g) {
		paint(g);
	}

	public void paint(Graphics g) {
		g.drawImage(img, 0, 0, this);
	}

	public boolean action(Event e, Object arg) {
		if (e.target instanceof Button) {
			String label = (String)arg;
			if (label.equals("Reset"))
				ip.reset();
			else if (label.equals("Flip"))
				ip.flipVertical();
			else if (label.equals("Invert"))
				ip.invert();
			else if (label.equals("Lighten"))
				ip.multiply(1.1);
			else if (label.equals("Darken"))
				ip.multiply(0.9);
			else if (label.equals("Rotate"))
				ip.rotate(30);
			else if (label.equals("Zoom In"))
				ip.scale(1.2, 1.2);
			else if (label.equals("Zoom Out"))
				ip.scale(0.8, 0.8);
			else if (label.equals("Threshsold"))
				ip.autoThreshold();
			else if (label.equals("Smooth"))
				ip.smooth();
			else if (label.equals("Sharpen"))
				ip.sharpen();
			else if (label.equals("Find Edges"))
				ip.findEdges();
			else if (label.equals("Macro 1"))
				macro1();
			else if (label.equals("Macro 2"))
				macro2();
			else if (label.equals("Add Noise"))
				ip.noise(20);
			img = ip.createImage();
			repaint();
			return true;
		}
		return false;
	}
	
	void updateAndDraw() {
		img.flush();
		img = ip.createImage();
		getGraphics().drawImage(img, 0, 0, this);
	}

	void macro1() {
		for (int i=10; i<=360; i+=10) {
			ip.reset();
			ip.rotate(i);
			updateAndDraw();
		}
	}
	
	void macro2() {
		double scale = 1, m = 1.2;
		for (int i=0; i<20; i++) {
			ip.reset();
			scale *= m;
			ip.scale(scale, scale);
			updateAndDraw();
		}
		for (int i=0; i <20; i++) {
			ip.reset();
			scale /= m;
			ip.scale(scale, scale);
			updateAndDraw();
		}
	}
	

}
