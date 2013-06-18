#include "ofMain.h"
#include "ofAppGlutWindow.h"
#include "ofxOsc/ofxOsc.h"

#include "processing.h"

final int n_panels = 10;
final int OneW = 96;
final int OneH = 96*4;
final int width = OneW*n_panels;
final int height = OneH;
final boolean debug = true;

final int n_sprites = 35; 
final int n_blobs = 3;

final int spacing = 15;
final int milestones[]  = {
	200, 400, 800, 1000, 1200, 1400,
}; 


void ofLine2(float x1,float y1,color c1, float x2,float y2, color c2)
{
	static float linePoints[4];
	static float col[8];
	linePoints[0] = x1;
	linePoints[1] = y1;
	linePoints[2] = x2;
	linePoints[3] = y2;
	col[0] = c1.r/255;
	col[1] = c1.g/255;
	col[2] = c1.b/255;
	col[3] = c1.a/255;
	col[4] = c2.r/255;
	col[5] = c2.g/255;
	col[6] = c2.b/255;
	col[7] = c2.a/255;

	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, &linePoints[0]); 
	glColorPointer(4, GL_FLOAT, 0, &col[0]);

	glDrawArrays(GL_LINES, 0, 2);

	glDisableClientState(GL_VERTEX_ARRAY); 
	glDisableClientState(GL_COLOR_ARRAY);

}

class Sprite
{
	float x;
	float y;
	float vx, _vx;
	float ix;
	int id;
	float h0;
	float h_k, _h_k;
	float w0;
	float w_k, _w_k;
	color clr_a, clr_b;

	//	PGraphics pg;

	void setup(boolean isLeft, int start_x, int end_x)
	{
		static int index = 0;
		x = 0;
		y = random(spacing, height-spacing); 
		ix = 0;
		id = index++;
		h0 = random(3, 12); 
		w0 = random(2, 4); 
		go_zero();

		if (isLeft)
		{
			int r = 0, g=(int)random(68, 200), b=200;
			clr_a = color(r, g, b, 0);
			clr_b = color(r, g, b, 170);
			//  clr = color(0, random(68, 200), 200, random(200, 250));
		}
		else  
		{
			int b = 0, r=(int)random(100, 200), g=244;
			clr_a = color(r, g, b, 0);
			clr_b = color(r, g, b, 170);      
			//clr = color(random(68, 200), 200, 0, random(200, 250));
		}
		x = random(start_x, end_x);
	}

	void update(int spd, int m)
	{
		if (spd < 2) spd = 2;
		float k = spd/10.0f;
		k *= k;
		_vx = k*100;
		_h_k = spd*14;
		_w_k = k*spacing*0.8;
	}

	void go_zero()
	{
		vx = _vx = 0;
		w_k = _w_k = 0;
		h_k = _h_k = 0;
	}

	void draw()
	{
		//    h_k = lerp(h_k, _h_k, 0.1);
		//   vx = lerp(vx, _vx, 0.1);
		//  w_k = lerp(w_k, _w_k, 0.1);
		vx = max(vx, 1);
		// h_k = max(h_k, 3);
		float w = w0* w_k;
		float idx = (frameCount+id*10)*0.05;
		ix = sin(idx);    
		ix = ix*ix;
		if (ix < 0.1) ix *= 2;
		ix *=vx;
		// x += ix;
		y -= ix;
		if (y < 0)
		{
			y = height+h_k*2;
			h_k = _h_k;
			w_k = _w_k;
			vx = _vx;
		}
		strokeWeight(w);
		ofLine2(x,y-h_k*0.25,clr_a, x, y-h_k*0.95, clr_b);
// 		beginShape(LINES);
// 		stroke(clr_a);
// 		vertex(x, y-h_k*0.25);
// 		stroke(clr_b);
// 		vertex(x, y-h_k*0.95);    
// 		endShape();

		strokeWeight(w*0.75);
		ofLine2(x,y,clr_a, x, y-h_k+2, clr_b);
// 		beginShape(LINES);
// 		stroke(clr_a);
// 		vertex(x, y);
// 		stroke(clr_b);
// 		vertex(x, y-h_k+2);    
// 		endShape();   

		strokeWeight(w/4);
		ofLine2(x,y,clr_a, x, y-h_k+4, clr_b);
// 		beginShape(LINES);
// 		stroke(clr_a);
// 		vertex(x, y); 
// 		stroke(clr_b);
// 		vertex(x, y-h_k+4);  
// 		endShape();
	}
};

class OnePanel
{
	color clr;

	int speed;
	int miles;
	int idx;
	Sprite sprites[n_sprites];
	int vfx_millis;
	boolean vfx_mode;

	//	PGraphics pg1;
	int vy[n_blobs][OneH/4];
	int vx[n_blobs][OneW/4];

	float blogPx[n_blobs];
	float blogPy[n_blobs];

	String vfx_text;

	void setup(int id)
	{
		speed = 0;
		miles = 0;  
		vfx_mode = false;
		vfx_text="";

		idx = id;
		boolean isLeft = idx < 5;
		for (int i=0;i<n_sprites;i++)
			sprites[i].setup(isLeft, OneW*idx+spacing, OneW*(idx+1)-spacing);
		//pg1 = createGraphics(60, 30, P2D);
		//pg1.textFont(font);
		if (isLeft)
		{
			int r = 0, g=(int)random(68, 200), b=200;
			clr = color(r, g, b, 200);
		}
		else  
		{
			int b = 0, r=(int)random(68, 200), g=200;
			clr = color(r, g, b, 200);
		}

		for (int i=0;i<n_blobs;i++)
		{
			blogPx[i] = OneW/8;
			blogPy[i] = OneH/8;
		}
	}

	void reset()
	{
		speed = 0;
		miles = 0;
	}

	void launch_vfx(int vid)
	{
		//println(idx+"´ïµ½ÁË"+milestones[vid]);
		vfx_mode = true;
		vfx_millis = millis();
		vfx_text = milestones[vid]+"M";
	}

	void update(int spd, int m)
	{
		for (int i=0;i<4;i++)
		{
			if (m < milestones[i]) 
				break;
			if (miles < milestones[i])
			{
				launch_vfx(i);
				break;
			}
		}
		for (int i=0;i<n_sprites;i++)
			sprites[i].update(spd, m); 
		speed = spd;
		miles = m;
	}

	void pg2_update()
	{
		for (int i=0; i<n_blobs; ++i) 
		{
			for (int x = 0; x < OneW/4; x++) {
				vx[i][x] = int(sq(blogPx[i]-x));
			}
			for (int y = 0; y < OneH/4; y++) {
				vy[i][y] = int(sq(blogPy[i]-y));
			}
		}
		for (int y = 0; y < OneH/4; y++) {
			for (int x = 0; x < OneW/4; x++) {
				int m = 1;
				for (int i = 0; i < n_blobs; i++) {
					// Increase this number to make your blobs bigger
					m += 6000/(vy[i][y] + vx[i][x]+1);
				}
				//   tex1.pixels[OneW/4*idx+x+y*pg2.width] = color(0, m, m/2,100);
			}
		}
	}
	void draw()
	{
		if (vfx_mode)
		{
#if 0
			if (millis - vfx_millis > 3000)
			{
				vfx_mode = false;
			}
			else
			{
				pg1.beginDraw();
				pg1.background(0, 122);
				pg1.fill(255, 255, 255, 255);
				pg1.text(vfx_text, 0, 20);
				pg1.endDraw();

				image(pg1, 15+OneW*idx, 160, pg1.width*2, pg1.height*2);
			}
#endif
		}
		//draw lines
		for (int i=0;i<n_sprites;i++)
		{
			if (debug)
			{
				ofSetLineWidth(1);
				ofSetColor(255, 255, 255);
				ofNoFill();
				ofSetRectMode(OF_RECTMODE_CORNER);
				ofRect(OneW*i, 0, OneW, OneH);
			}
			sprites[i].draw();
		}
	}
};


class PanelApp : public ofBaseApp
{
	ofxOscReceiver recv;
	OnePanel panels[n_panels];

	void setup()
	{
		recv.setup(3334);
		ofSetFrameRate(60);
		for (int i=0;i<n_panels;i++)
		{
			panels[i].setup(i);
		}
	}

	void update()
	{
		while( recv.hasWaitingMessages() )
		{
			// get the next message
			ofxOscMessage m;
			recv.getNextMessage( &m );

			String addr = m.getAddress();
			// check for mouse moved message
			if ( addr == "/msg" )
			{  
				if (m.getNumArgs() == 3)
				{
					int id = m.getArgAsInt32(0);
					int speed = m.getArgAsInt32(1);
					int miles = m.getArgAsInt32(2);
					panels[id].update(speed, miles);
				}
			}
			else if (addr == "/start")
			{ 
				println("/start");
				for (int i=0;i<n_panels;i++)
					panels[i].reset();
			} 
		}
	}

	void draw()
	{
		background(0,0,0);
		ofEnableAlphaBlending(); 
//		glBlendFunc(GL_SRC_ALPHA, GL_DST_ALPHA); 

		for (int i=0;i<n_panels;i++)
		{
			panels[i].draw();
		}
		ofDisableAlphaBlending();
	}
};


int main( ){

	ofAppGlutWindow window;
	ofSetupOpenGL(&window, width, height, OF_WINDOW);

	ofRunApp( new PanelApp());
}
