/**
 * RubiksCube java 
 * 
 * 20160823 復活
 * 20160824 insertionSort
 * 20160825 selectionSort
 * 20160826 bubbleSort/quickSort
 *  mergeSort
 *  shellSort
 *  quickSort
 *  heapSort
 *  topologicalSort
 */
import java.applet.Applet;
import java.awt.BorderLayout;
import java.awt.Canvas;
import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Event;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.Insets;
import java.awt.LayoutManager;
import java.awt.Panel;
import java.awt.Point;
/**
 * class Rubikscube RubiksCubeクラス
 * ボタンコントロールのレイアウト、アクションの設定
 * @author suzukiiichiro
 */
public class RubiksCube extends Applet implements Setting {
	private static final long serialVersionUID = 1L;
	static int MAXBTN = 2;
	static int MAXEDGE = 5;
	int level = -1;
	Viewport viewport;
	Panel controls;
	Panel3D p1;
	Panel3D p2;
	Label3D lbLevel;
	Button3D[] btn;
	Button3D[] edge;
	Button3D original;
	Button3D arrange;
	Button3D puzzle;
	Button3D solve;
	Button3D dec;
	Button3D inc;
	/**
	 * init()
	 * ボタンコントロールの配置
	 */
	public void init() {
		this.btn = new Button3D[MAXBTN];
		this.edge = new Button3D[MAXEDGE];
		setLayout(new BorderLayout());
		add("South", this.controls = new Panel());
		this.controls.setLayout(new GridLayout(2, 1));
		this.controls.add(this.p1 = new Panel3D(-1, 3));
		this.controls.add(this.p2 = new Panel3D(-1, 1));
		this.p1.setLayout(new GridLayout(1, 4, 4, 4));
		this.p1.add(this.btn[0] = new Button3D(9, "Cube"));
		this.p1.add(this.btn[1] = new Button3D(9, "Face"));
		this.p1.add(this.original = new Button3D("Original"));
		this.p1.add(this.arrange = new Button3D("Arrange"));
		this.p1.add(this.lbLevel = new Label3D(""));
		this.p2.setLayout(new FlowLayout(1, 4, 4));
		this.p2.add(this.puzzle = new Button3D("Puzzle"));
		this.p2.add(this.solve = new Button3D("Solve"));
		this.p2.add(this.edge[0] = new Button3D(9, "2"));
		this.p2.add(this.edge[1] = new Button3D(9, "3"));
		this.p2.add(this.edge[2] = new Button3D(9, "4"));
		this.p2.add(this.edge[3] = new Button3D(9, "5"));
		this.p2.add(this.edge[4] = new Button3D(9, "6"));
		this.p2.add(this.dec = new Button3D("-"));
		this.p2.add(this.inc = new Button3D("+"));
		this.puzzle.setRatio(3);
		this.solve.setRatio(3);
		add("Center", this.viewport = new Viewport());
		setLevel(5);
		setMode(0);
		setEdge(1, false);
	}
	/**
	 * setMmode() 
	 * @param paramInt
	 */
	void setMode(int paramInt) {
		this.viewport.mode = paramInt;
		for (int i = 0; i < MAXBTN; i++) {
			this.btn[i].setActive(i != paramInt);
		}
	}
	/**
	 * setEdge()
	 * @param paramInt
	 * @param paramBoolean
	 */
	void setEdge(int paramInt, boolean paramBoolean) {
		this.viewport.setNEDGE(paramInt + 2, paramBoolean);
		for (int i = 0; i < MAXEDGE; i++) {
			this.edge[i].setActive(i != paramInt);
		}
	}
	/**
	 * setLevel()
	 * @param paramInt
	 */
	void setLevel(int paramInt) {
		if (paramInt > 10) {
			paramInt = 10;
		}
		if (paramInt < 1) {
			paramInt = 1;
		}
		if (this.level == paramInt) {
			return;
		}
		Viewport.LEVEL = this.level = paramInt;
		this.inc.setActive(this.level < 10);
		this.dec.setActive(this.level > 1);
		this.lbLevel.setText("Level:" + this.level);
	}
	/**
	 * action()
	 * ボタンアクションの設定
	 */
	public boolean action(Event paramEvent, Object paramObject) {
		if (paramObject == this.btn[0]) {
			setMode(0);
		} else if (paramObject == this.btn[1]) {
			setMode(1);
		} else if (paramObject == this.edge[0]) {
			setEdge(0, true);
		} else if (paramObject == this.edge[1]) {
			setEdge(1, true);
		} else if (paramObject == this.edge[2]) {
			setEdge(2, true);
		} else if (paramObject == this.edge[3]) {
			setEdge(3, true);
		} else if (paramObject == this.edge[4]) {
			setEdge(4, true);
		} else if (paramObject == this.original) {
			this.viewport.Original();
		} else if (paramObject == this.arrange) {
			this.viewport.Arrange(true);
		} else if (paramObject == this.puzzle) {
			this.viewport.Random();
		} else if (paramObject == this.solve) {
			this.viewport.Solve();
		} else if (paramObject == this.inc) {
			setLevel(this.level + 1);
		} else if (paramObject == this.dec) {
			setLevel(this.level - 1);
		}
		return false;
	}
}
/**
 * interface Setting Settingインタフェース
 * @author suzukiiichiro
 */
interface Setting {
	public static final int XMAX = 96;
	public static final int YMAX = 55;
	public static final int ZMAX = 33;
	public static final int depth = 2;
	public static final int d2 = 4;
	public static final Color white = Color.white;
	public static final Color ltGray = Color.white;
	public static final Color dkGray = Color.gray;
	public static final Color gray = Color.lightGray;
	public static final Color black = Color.black;
	public static final Font bfont = new Font("TimesRoman", 1, 14);
	public static final LayoutManager flow = new FlowLayout(1, 4, 4);
	public static final Insets insets = new Insets(2, 2, 2, 2);
}
/**
 * class AI AIクラス
 * @author suzukiiichiro
 */
class AI {
	/**
	 * AI() コンストラクタ
	 */
	public AI() {
	}
	/**
	 * swap() スワップ関数
	 * @param A   this.order
	 * @param one 0
	 * @param two NCUBE
	 */
	public void swap(int[] A, int one, int two) {
		int tmp = A[one];
		A[one] = A[two];
		A[two] = tmp;
	}
	/**
	 * quickSort() クイックソート
	 * @param paramArrayOfDouble
	 * @param paramArrayOfInt
	 * @param paramInt1
	 * @param paramInt2
	 */
	public void quickSort(double[] a, int[] A, int start, int nElems) {
		if (start >= nElems) {
			return;
		}
		int i = start - 1;
		int j = nElems + 1;
		int k = (start + nElems) / 2;
		int m = A[k];
		A[k] = A[start];
		double tmp = a[(A[start] = m)];
		while (true) {
			if (a[A[(--j)]] <= tmp) {
				while ((a[A[(++i)]] < tmp)) {
				}
				if (i >= j) {
					break;
				}
				swap(A, i, j);
			}
		}
		quickSort(a, A, start, j);
		quickSort(a, A, j + 1, nElems);
	}
	/**
	 * insertionSort() 挿入ソート
	 * @param a   this.value
	 * @param A   this.order
	 * @param start  0
	 * @param nElems NCUBE
	 */
	public void insertionSort(double[] a, int[] A, int start, int nElems) {
		for (int out = start; out < nElems; out++) {
			double tmp = a[out];
			int in;
			for (in = out - 1; in >= 0 && a[A[in]] > tmp; in--) {
				A[in + 1] = A[in];
			}
			A[in + 1] = out;
		}
	}
	/**
	 * selectionSort() 選択ソート
	 * @param a  this.value
	 * @param A  this.order
	 * @param start  0
	 * @param nElems NCUBE
	 */
	public void selectionSort(double[] a, int[] A, int start, int nElems) {
		int out, in, min;
		for (out = start; out < nElems - 1; out++) {
			min = out;
			for (in = out + 1; in < nElems; in++) {
				if (a[A[in]] < a[A[min]]) {
					min = in;
				}
			}
			swap(A, out, min);
		}
	}
	/**
	 * bubbleSort() バブルソート
	 * @param a       this.value
	 * @param A       this.order
	 * @param start   0
	 * @param nElems  NCUBE
	 */
	public void bubbleSort(double[] a, int[] A, int start, int nElems) {
		int out, in;
		for (out = nElems - 1; out > 1; out--) {
			for (in = 0; in < out; in++) {
				if (a[A[in]] > a[A[in + 1]]) {
					swap(A, in, in + 1);
				}
			}
		}
	}
	/**
	 * quickSort() クイックソート 基のバージョン
	 * @param paramArrayOfDouble
	 * @param paramArrayOfInt
	 * @param paramInt1
	 * @param paramInt2
	 */
	public void quickSort1(double[] paramArrayOfDouble, int[] paramArrayOfInt, int paramInt1, int paramInt2) {
		if (paramInt1 >= paramInt2) {
			return;
		}
		int i = paramInt1 - 1;
		int j = paramInt2 + 1;
		int k = (paramInt1 + paramInt2) / 2;
		int m = paramArrayOfInt[k];
		paramArrayOfInt[k] = paramArrayOfInt[paramInt1];
		double d = paramArrayOfDouble[(paramArrayOfInt[paramInt1] = m)];
		for (;;) {
			if (paramArrayOfDouble[paramArrayOfInt[(--j)]] <= d) {
				// while ((goto 70) ||
				// (paramArrayOfDouble[paramArrayOfInt[(++i)]] < d)) {}
				while ((paramArrayOfDouble[paramArrayOfInt[(++i)]] < d)) {
				}
				if (i >= j) {
					break;
				}
				m = paramArrayOfInt[i];
				paramArrayOfInt[i] = paramArrayOfInt[j];
				paramArrayOfInt[j] = m;
			}
		}
		quickSort(paramArrayOfDouble, paramArrayOfInt, paramInt1, j);
		quickSort(paramArrayOfDouble, paramArrayOfInt, j + 1, paramInt2);
	}
	/**
	 * insertionSort() 挿入ソート 基のバージョン
	 * @param paramArrayOfDouble
	 * @param paramArrayOfInt
	 * @param paramInt1
	 * @param paramInt2
	 */
	public void insertionSort1(double[] paramArrayOfDouble, int[] paramArrayOfInt, int paramInt1, int paramInt2) {
		for (int j = paramInt1 + 1; j <= paramInt2; j++) {
			double d = paramArrayOfDouble[j];
			int i;
			for (i = j - 1; (i >= 0) && (paramArrayOfDouble[paramArrayOfInt[i]] > d); i--) {
				// for (int i = j - 1; (i >= 0) &&
				// (paramArrayOfDouble[paramArrayOfInt[i]] > d); i--) {
				paramArrayOfInt[(i + 1)] = paramArrayOfInt[i];
			}
			paramArrayOfInt[(i + 1)] = j;
		}
	}
}
/**
 * class Viewport Viewportクラス
 * @author suzukiiichiro
 */
class Viewport extends Canvas3D {
	private static final long serialVersionUID = 1L;
	static final Color[] colors = { Color.white, Color.yellow, Color.red, new Color(255, 128, 64), Color.green,
			Color.blue };
	static final int CUBE = 0;
	static final int FACE = 1;
	static final double ERR = 0.1D;
	static int LEVEL;
	static int NEDGE;
	static int NCUBE;
	Point3D hit;
	Point3D hp;
	Point3D dp;
	Point3D ap;
	boolean pressed = false;
	int mx;
	int my;
	int direction;
	int hid;
	Cube[] cube;
	double[] value;
	int[] order;
	int w;
	int h;
	Image image;
	double scale;
	Point2D ct;
	Point2D base;
	int mode;
	Point3D origin;
	Point2D vangle;
	Coordinate coord;
	Coordinate backup;
	Exclusive exclusive;
	int[] recCell;
	int recSize;
	int recPtr;
	/**
	 * Viewport() コンストラクタ
	 */
	public Viewport() {
		setBackground(Setting.black);
		this.exclusive = new Exclusive();
		this.coord = new Coordinate();
		this.recCell = new int[this.recSize = 128];
		this.recPtr = 0;
	}
	/**
	 * updateOffScr()
	 */
	void updateOffScr() {
		if (this.image == null) {
			return;
		}
		Graphics localGraphics = this.image.getGraphics();
		Draw3DRect(localGraphics, -2, Setting.black);
		for (int i = 0; i < NCUBE; i++) {
			this.value[i] = this.cube[i].getDist(this.coord);
		}
		/**
		 * ソート各種
		 */
		//new AI().bubbleSort(this.value, this.order, 0, NCUBE) ;
		//new AI().selectionSort(this.value, this.order, 0, NCUBE);
		//new AI().insertionSort(this.value, this.order, 0, NCUBE);
		new AI().quickSort(this.value, this.order, 0, NCUBE-1);

		for (int j = NCUBE - 1; j >= 0; j--) {
			this.cube[this.order[j]].draw(localGraphics, this.coord);
		}
		localGraphics.dispose();
	}
	/**
	 * atan2()
	 * @param paramDouble1
	 * @param paramDouble2
	 * @return
	 */
	double atan2(double paramDouble1, double paramDouble2) {
		if (paramDouble1 == 0.0D) {
			if (paramDouble2 >= 0.0D) {
				return 0.0D;
			}
			return -3.141592653589793D;
		}
		if (paramDouble2 == 0.0D) {
			if (paramDouble1 > 0.0D) {
				return 1.5707963267948966D;
			}
			return -1.5707963267948966D;
		}
		return Math.atan2(paramDouble1, paramDouble2);
	}
	/**
	 * record()
	 * @param paramInt1
	 * @param paramInt2
	 * @param paramInt3
	 */
	void record(int paramInt1, int paramInt2, int paramInt3) {
		if ((paramInt3 &= 0x3) == 0) {
			return;
		}
		if (this.recPtr + 1 == this.recSize) {
			int[] arrayOfInt = new int[this.recSize *= 2];
			System.arraycopy(this.recCell, 0, arrayOfInt, 0, this.recCell.length);
		}
		if (this.recPtr > 0) {
			int i = this.recCell[(this.recPtr - 1)];
			int j = i / 256;
			int k = i / 16 & 0x3;
			if ((k == paramInt2) && (((paramInt2 == 0)
					&& (Math.abs(this.cube[paramInt1].bp.x - this.cube[j].bp.x) < 0.1D))
					|| ((paramInt2 == 1) && (Math.abs(this.cube[paramInt1].bp.y - this.cube[j].bp.y) < 0.1D))
					|| ((paramInt2 == 2) && (Math.abs(this.cube[paramInt1].bp.z - this.cube[j].bp.z) < 0.1D)))) {
				paramInt3 = paramInt3 + (i & 0x3) & 0x3;
				this.recPtr -= 1;
			}
		}
		this.recCell[(this.recPtr++)] = (paramInt1 * 256 + paramInt2 * 16 + paramInt3);
	}
	/**
	 * reset()
	 */
	void reset() {
		this.recPtr = 0;
	}
	/**
	 * playBack()
	 * @return
	 */
	boolean playBack() {
		if (this.recPtr > 0) {
			int i = this.recCell[(--this.recPtr)];
			int j = i / 256;
			int k = i / 16 & 0x3;
			int m = 4 - (i & 0x3) & 0x3;
			Animate(j, k, m);
			Rotate(j, k, m, false, true);
			new Delay(1000L);
			return true;
		}
		return false;
	}
	/**
	 * Animate()
	 * @param paramInt1
	 * @param paramInt2
	 * @param paramInt3
	 */
	void Animate(int paramInt1, int paramInt2, int paramInt3) {
		int i = (paramInt3 &= 0x3) == 3 ? -1 : paramInt3;
		Point3D localPoint3D = new Point3D(this.cube[paramInt1].bp);
		int j = 6;
		int k = i > 0 ? 1 : -1;
		int n = k * i * j;
		double d2 = 1.5707963267948966D / j * k;
		int m = 0;
		for (double d1 = 0.0D; m < n; d1 += d2) {
			switch (paramInt2) {
				case 0:
					RotateX(localPoint3D, d1);
					break;
				case 1:
					RotateY(localPoint3D, d1);
					break;
				default:
					RotateZ(localPoint3D, d1);
			}
			this.exclusive.enter();
			repaint();
			this.exclusive.leave();
			m++;
		}
	}
	/**
	 * Rotate()
	 * @param paramInt1
	 * @param paramInt2
	 * @param paramInt3
	 * @param paramBoolean1
	 * @param paramBoolean2
	 */
	void Rotate(int paramInt1, int paramInt2, int paramInt3, boolean paramBoolean1, boolean paramBoolean2) {
		Point3D localPoint3D = new Point3D(this.cube[paramInt1].bp);
		double d = 1.5707963267948966D * (paramInt3 &= 0x3);
		switch (paramInt2) {
			case 0:
				RotateX(localPoint3D, d);
				break;
			case 1:
				RotateY(localPoint3D, d);
				break;
			default:
				RotateZ(localPoint3D, d);
		}
		for (int i = 0; i < NCUBE; i++) {
			this.cube[i].updateBase();
		}
		if (paramBoolean1) {
			record(paramInt1, paramInt2, paramInt3);
		}
		if (paramBoolean2) {
			this.exclusive.enter();
			repaint();
			this.exclusive.leave();
		}
	}
	/**
	 * setNEDGE()
	 * @param paramInt
	 * @param paramBoolean
	 */
	public void setNEDGE(int paramInt, boolean paramBoolean) {
		this.exclusive.enter();
		NEDGE = paramInt;
		NCUBE = NEDGE * NEDGE * NEDGE;
		this.cube = new Cube[NCUBE];
		this.value = new double[NCUBE];
		this.order = new int[NCUBE];
		this.vangle = new Point2D(0.7853981633974483D, 0.7853981633974483D);
		this.coord.setValue(new Point3D(0.0D, -7.0D * NEDGE / 3.0D, 0.0D));
		this.coord.SetViewAngle(new Point2D());
		this.coord.RotateBase(this.vangle, new Point3D());
		this.origin = this.coord;
		for (int i = 0; i < NCUBE; i++) {
			this.order[i] = i;
		}
		this.exclusive.leave();
		Arrange(paramBoolean);
	}
	/**
	 * Original()
	 */
	public void Original() {
		this.exclusive.enter();
		this.coord.SetViewAngle(this.vangle);
		this.coord.setValue(this.origin);
		updateOffScr();
		repaint();
		this.exclusive.leave();
	}
	/**
	 * Random()
	 */
	public void Random() {
		Arrange(true);
		for (int i = 0; i < LEVEL * NEDGE; i++) {
			Rotate((int) (Math.random() * NCUBE), (int) (Math.random() * 3.0D), (int) (Math.random() * 3.0D + 1.0D),
					true, true);
		}
	}
	/**
	 * Solve() 
	 */
	public void Solve() {
		while (playBack()) {
		}
	}
	/**
	 * Arrange()
	 * @param paramBoolean
	 */
	public void Arrange(boolean paramBoolean) {
		this.exclusive.enter();
		double d1 = 1.2D;
		double d2 = (NEDGE - 1.0D) / 2.0D;
		Color[] arrayOfColor = new Color[6];
		for (int i = 0; i < NEDGE; i++) {
			for (int j = 0; j < NEDGE; j++) {
				for (int k = 0; k < NEDGE; k++) {
					arrayOfColor[0] = (i == 0 ? colors[0] : Color.gray);
					arrayOfColor[1] = (i == NEDGE - 1 ? colors[1] : Color.gray);
					arrayOfColor[2] = (j == 0 ? colors[2] : Color.lightGray);
					arrayOfColor[3] = (j == NEDGE - 1 ? colors[3] : Color.lightGray);
					arrayOfColor[4] = (k == 0 ? colors[4] : Color.darkGray);
					arrayOfColor[5] = (k == NEDGE - 1 ? colors[5] : Color.darkGray);
					this.cube[((i * NEDGE + j) * NEDGE + k)] = new Cube(
							new Point3D((i - d2) * d1, (j - d2) * d1, (k - d2) * d1), arrayOfColor);
				}
			}
		}
		reset();
		updateOffScr();
		if (paramBoolean) {
			repaint();
		}
		this.exclusive.leave();
	}
	/**
	 * update()
	 */
	public void update(Graphics paramGraphics) {
		if (paramGraphics == null) {
			return;
		}
		Dimension localDimension = getSize();
		if ((this.image == null) || (this.w != localDimension.width) || (this.h != localDimension.height)) {
			this.exclusive.enter();
			this.w = Math.max(2, localDimension.width);
			this.h = Math.max(2, localDimension.height);
			this.image = createImage(this.w, this.h);
			this.ct = (this.coord.center = new Point2D(this.w / 2, this.h / 2));
			this.scale = (this.coord.scale = Math.min(this.w, this.h));
			updateOffScr();
			this.exclusive.leave();
		}
		paramGraphics.drawImage(this.image, 0, 0, this);
	}
	/**
	 * Point3D()
	 * @param paramPoint3D1
	 * @param paramPoint3D2
	 * @param paramPoint3D3
	 * @param paramPoint3D4
	 * @return
	 */
	public Point3D crossPoint(Point3D paramPoint3D1, Point3D paramPoint3D2, Point3D paramPoint3D3,
			Point3D paramPoint3D4) {
		Point3D localPoint3D2 = paramPoint3D2.sub(paramPoint3D1);
		Point3D localPoint3D4 = paramPoint3D4.sub(paramPoint3D3);
		double d2 = localPoint3D4.dot(localPoint3D4);
		localPoint3D2 = localPoint3D2.div(Math.sqrt(localPoint3D2.dot(localPoint3D2)));
		Point3D localPoint3D1 = localPoint3D2.mul(paramPoint3D3.sub(paramPoint3D1).dot(localPoint3D2))
				.add(paramPoint3D1);
		Point3D localPoint3D3 = localPoint3D1.sub(paramPoint3D3);
		double d1 = localPoint3D3.dot(localPoint3D3);
		if (d1 < d2) {
			return localPoint3D1.sub(localPoint3D2.mul(Math.sqrt(d2 - d1)));
		}
		return paramPoint3D3.add(localPoint3D3.mul(Math.sqrt(d2 / d1)));
	}
	/**
	 * delayDrag()
	 */
	public boolean delayDrag(Event paramEvent, int paramInt1, int paramInt2) {
		this.exclusive.enter();
		if (this.pressed) {
			Point3D localPoint3D1 = crossPoint(this.backup,
					this.backup.Prospect(new Point2D(paramInt1, paramInt2), 1.0F), new Point3D(), this.hit);
			Object localObject;
			if (this.mode == 0) {
				localObject = this.backup.VectorAngle(localPoint3D1).sub(this.base);
				this.coord = new Coordinate(this.backup);
				this.coord.RotateBase(new Point2D(((Point2D) localObject).x, ((Point2D) localObject).y), new Point3D());
				updateOffScr();
			} else {
				localObject = new Point3D(atan2(localPoint3D1.y, localPoint3D1.z),
						atan2(localPoint3D1.z, localPoint3D1.x), atan2(localPoint3D1.x, localPoint3D1.y));
				Point3D localPoint3D2 = ((Point3D) localObject).sub(this.ap);
				double d1 = 0.7853981633974483D;
				double d2 = 0.39269908169872414D;
				int i = this.direction;
				if ((this.direction < 0)
						|| ((-d1 < localPoint3D2.x) && (localPoint3D2.x < d1) && (-d1 < localPoint3D2.y)
								&& (localPoint3D2.y < d1) && (-d1 < localPoint3D2.z) && (localPoint3D2.z < d1))) {
					int j = (-d2 >= localPoint3D2.x) || (localPoint3D2.x >= d2) || (-d2 >= localPoint3D2.y)
							|| (localPoint3D2.y >= d2) || (-d2 >= localPoint3D2.z) || (localPoint3D2.z >= d2) ? 0 : 1;
					Point3D localPoint3D3 = new Point3D(this.hp.x, this.dp.x * Math.sin(((Point3D) localObject).x),
							this.dp.x * Math.cos(((Point3D) localObject).x));
					Point3D localPoint3D4 = new Point3D(this.dp.y * Math.cos(((Point3D) localObject).y), this.hp.y,
							this.dp.y * Math.sin(((Point3D) localObject).y));
					Point3D localPoint3D5 = new Point3D(this.dp.z * Math.sin(((Point3D) localObject).z),
							this.dp.z * Math.cos(((Point3D) localObject).z), this.hp.z);
					Point3D localPoint3D6 = localPoint3D1.sub(this.hit);
					double d3 = localPoint3D3.sub(this.hit).dot(localPoint3D6);
					if (j == 0) {
						this.direction = 0;
						double d4;
						if (d3 < (d4 = localPoint3D4.sub(this.hit).dot(localPoint3D6))) {
							d3 = d4;
							this.direction = 1;
						}
						if (d3 < localPoint3D5.sub(this.hit).dot(localPoint3D6)) {
							this.direction = 2;
						}
					} else {
						this.direction = -1;
					}
					if (this.direction != i) {
						switch (i) {
							case 0:
								RotateX(this.hp, 0.0D);
								break;
							case 1:
								RotateY(this.hp, 0.0D);
								break;
							case 2:
								RotateZ(this.hp, 0.0D);
								break;
						}
					}
				}
				switch (this.direction) {
					case 0:
						RotateX(this.hp, localPoint3D2.x);
						break;
					case 1:
						RotateY(this.hp, localPoint3D2.y);
						break;
					case 2:
						RotateZ(this.hp, localPoint3D2.z);
						break;
					default:
						if (this.direction == i) {
							this.exclusive.leave();
							return true;
						}
						break;
				}
			}
			repaint();
		}
		this.exclusive.leave();
		return true;
	}
	/**
	 * mouseDown()
	 */
	public boolean mouseDown(Event paramEvent, int paramInt1, int paramInt2) {
		if (this.pressed) {
			return true;
		}
		this.exclusive.enter();
		this.hit = null;
		this.mx = paramInt1;
		this.my = paramInt2;
		for (int i = 0; i < NCUBE; i++) {
			this.hit = this.cube[(this.hid = this.order[i])].check(new Point(paramInt1, paramInt2), this.coord);
			if (this.hit != null) {
				this.hp = new Point3D(this.cube[this.hid]);
				this.direction = -1;
				this.ap = new Point3D(atan2(this.hp.y, this.hp.z), atan2(this.hp.z, this.hp.x),
						atan2(this.hp.x, this.hp.y));
				this.dp = new Point3D(Math.sqrt(this.hp.y * this.hp.y + this.hp.z * this.hp.z),
						Math.sqrt(this.hp.z * this.hp.z + this.hp.x * this.hp.x),
						Math.sqrt(this.hp.x * this.hp.x + this.hp.y * this.hp.y));
				this.base = this.coord.VectorAngle(this.hit);
				this.backup = new Coordinate(this.coord);
				this.pressed = true;
				break;
			}
		}
		this.exclusive.leave();
		return true;
	}
	/**
	 * RotateX()
	 * @param paramPoint3D
	 * @param paramDouble
	 */
	void RotateX(Point3D paramPoint3D, double paramDouble) {
		double d1 = Math.cos(paramDouble);
		double d2 = Math.sin(paramDouble);
		for (int i = 0; i < NCUBE; i++) {
			Cube localCube = this.cube[i];
			if (Math.abs(paramPoint3D.x - localCube.x) < 0.1D) {
				double d3 = atan2(localCube.bp.y, localCube.bp.z) + paramDouble;
				double d4 = Math.sqrt(localCube.y * localCube.y + localCube.z * localCube.z);
				localCube.setValue(new Point3D(paramPoint3D.x, Math.sin(d3) * d4, Math.cos(d3) * d4));
				localCube.rotateX(d1, d2);
			}
		}
		updateOffScr();
	}
	/**
	 * RotateY()
	 * @param paramPoint3D
	 * @param paramDouble
	 */
	void RotateY(Point3D paramPoint3D, double paramDouble) {
		double d1 = Math.cos(paramDouble);
		double d2 = Math.sin(paramDouble);
		for (int i = 0; i < NCUBE; i++) {
			Cube localCube = this.cube[i];
			if (Math.abs(paramPoint3D.y - localCube.y) < 0.1D) {
				double d3 = atan2(localCube.bp.z, localCube.bp.x) + paramDouble;
				double d4 = Math.sqrt(localCube.z * localCube.z + localCube.x * localCube.x);
				localCube.setValue(new Point3D(Math.cos(d3) * d4, paramPoint3D.y, Math.sin(d3) * d4));
				localCube.rotateY(d1, d2);
			}
		}
		updateOffScr();
	}
	/**
	 * RotateZ()
	 * @param paramPoint3D
	 * @param paramDouble
	 */
	void RotateZ(Point3D paramPoint3D, double paramDouble) {
		double d1 = Math.cos(paramDouble);
		double d2 = Math.sin(paramDouble);
		for (int i = 0; i < NCUBE; i++) {
			Cube localCube = this.cube[i];
			if (Math.abs(paramPoint3D.z - localCube.z) < 0.1D) {
				double d3 = atan2(localCube.bp.x, localCube.bp.y) + paramDouble;
				double d4 = Math.sqrt(localCube.x * localCube.x + localCube.y * localCube.y);
				localCube.setValue(new Point3D(Math.sin(d3) * d4, Math.cos(d3) * d4, paramPoint3D.z));
				localCube.rotateZ(d1, d2);
			}
		}
		updateOffScr();
	}
	/**
	 * mouseUp()
	 */
	public boolean mouseUp(Event paramEvent, int paramInt1, int paramInt2) {
		if (!this.pressed) {
			return true;
		}
		this.exclusive.enter();
		this.pressed = false;
		if (this.mode == 1) {
			Cube localCube = this.cube[this.hid];
			double d1 = 1.5707963267948966D;
			double d2 = 0.7853981633974483D;
			switch (this.direction) {
				case 0:
					Rotate(this.hid, this.direction,
							(int) Math.floor((atan2(localCube.y, localCube.z) - this.ap.x + d2) / d1), true, false);
					break;
				case 1:
					Rotate(this.hid, this.direction,
							(int) Math.floor((atan2(localCube.z, localCube.x) - this.ap.y + d2) / d1), true, false);
					break;
				case 2:
					Rotate(this.hid, this.direction,
							(int) Math.floor((atan2(localCube.x, localCube.y) - this.ap.z + d2) / d1), true, false);
					break;
				default:
					this.exclusive.leave();
					return true;
			}
			repaint();
		}
		this.exclusive.leave();
		return true;
	}
}
/**
 * class Coordinate
 * @author suzukiiichiro
 *
 */
class Coordinate extends Point3D {
	Point3D X;
	Point3D Y;
	Point3D Z;
	Point2D center;
	int scale = 100;
	/**
	 * Coordinate() コンストラクタ
	 */
	Coordinate() {
	}
	/**
	 * Coordinate() コンストラクタ
	 * @param paramPoint3D
	 * @param paramPoint2D
	 */
	Coordinate(Point3D paramPoint3D, Point2D paramPoint2D) {
		super(paramPoint3D);
		SetViewAngle(paramPoint2D);
	}
	/**
	 * Coordinate() コンストラクタ
	 * @param paramCoordinate
	 */
	Coordinate(Coordinate paramCoordinate) {
		super(paramCoordinate);
		this.X = new Point3D(paramCoordinate.X);
		this.Y = new Point3D(paramCoordinate.Y);
		this.Z = new Point3D(paramCoordinate.Z);
		this.center = new Point2D(paramCoordinate.center);
		this.scale = paramCoordinate.scale;
	}
	/**
	 * SetViewAngle()
	 * @param paramPoint2D
	 */
	void SetViewAngle(Point2D paramPoint2D) {
		Point2D localPoint2D1 = new Point2D(Math.cos(paramPoint2D.x), Math.cos(paramPoint2D.y));
		Point2D localPoint2D2 = new Point2D(Math.sin(paramPoint2D.x), Math.sin(paramPoint2D.y));
		this.X = new Point3D(localPoint2D1.y, -localPoint2D2.y, 0.0D);
		this.Y = new Point3D(localPoint2D2.y * localPoint2D1.x, localPoint2D1.y * localPoint2D1.x, -localPoint2D2.x);
		this.Z = new Point3D(localPoint2D2.y * localPoint2D2.x, localPoint2D1.y * localPoint2D2.x, localPoint2D1.x);
	}
	/**
	 * Rotate()
	 * @param paramPoint2D
	 */
	void Rotate(Point2D paramPoint2D) {
		Point2D localPoint2D1 = new Point2D(Math.cos(paramPoint2D.x), Math.cos(paramPoint2D.y));
		Point2D localPoint2D2 = new Point2D(Math.sin(paramPoint2D.x), Math.sin(paramPoint2D.y));
		Point3D localPoint3D1 = this.X.mul(localPoint2D1.y).sub(this.Y.mul(localPoint2D2.y));
		Point3D localPoint3D2 = this.X.mul(localPoint2D2.y * localPoint2D1.x)
				.add(this.Y.mul(localPoint2D1.y * localPoint2D1.x)).sub(this.Z.mul(localPoint2D2.x));
		Point3D localPoint3D3 = this.X.mul(localPoint2D2.y * localPoint2D2.x)
				.add(this.Y.mul(localPoint2D1.y * localPoint2D2.x)).add(this.Z.mul(localPoint2D1.x));
		this.X = localPoint3D1;
		this.Y = localPoint3D2;
		this.Z = localPoint3D3;
	}
	/**
	 * RotateBase()
	 * @param paramPoint2D
	 * @param paramPoint3D
	 */
	void RotateBase(Point2D paramPoint2D, Point3D paramPoint3D) {
		Point3D localPoint3D = Transform(paramPoint3D);
		Rotate(paramPoint2D);
		subBy(Reverse(localPoint3D));
	}
	/**
	 * VectorAngle()
	 * @param paramPoint3D
	 * @return
	 */
	Point2D VectorAngle(Point3D paramPoint3D) {
		Point3D localPoint3D = new Point3D(this.X.dot(paramPoint3D), -this.Y.dot(paramPoint3D),
				this.Z.dot(paramPoint3D));
		return new Point2D(
				(float) Math.atan2(-localPoint3D.z,
						Math.sqrt(localPoint3D.x * localPoint3D.x + localPoint3D.y * localPoint3D.y)),
				(float) Math.atan2(localPoint3D.x, localPoint3D.y));
	}
	/**
	 * Transform() 
	 * @param paramPoint3D
	 * @return
	 */
	Point3D Transform(Point3D paramPoint3D) {
		Point3D localPoint3D = paramPoint3D.sub(this);
		return new Point3D(this.X.dot(localPoint3D), this.Y.dot(localPoint3D), this.Z.dot(localPoint3D));
	}
	/**
	 * Reverse()
	 * @param paramPoint3D
	 * @return
	 */
	Point3D Reverse(Point3D paramPoint3D) {
		return this.X.mul(paramPoint3D.x).add(this.Y.mul(paramPoint3D.y)).add(this.Z.mul(paramPoint3D.z)).add(this);
	}
	/**
	 * Prospect()
	 * @param paramPoint2D
	 * @param paramFloat
	 * @return
	 */
	Point3D Prospect(Point2D paramPoint2D, float paramFloat) {
		paramPoint2D = new Point2D(paramPoint2D.x, paramPoint2D.y).sub(this.center).mul(paramFloat / this.scale);
		return Reverse(new Point3D(paramPoint2D.x, paramFloat, -paramPoint2D.y));
	}
	/**
	 * Prospect()
	 * @param paramPoint3D
	 * @return
	 */
	Point2D Prospect(Point3D paramPoint3D) {
		return new Point2D(paramPoint3D.x, -paramPoint3D.z).mul(this.scale / paramPoint3D.y).add(this.center);
	}
	/**
	 * Project()
	 * @param paramPoint3D
	 * @return
	 */
	Point2D Project(Point3D paramPoint3D) {
		return Prospect(Transform(paramPoint3D));
	}
}
/**
 * class Delay ディレイクラス
 * @author suzukiiichiro
 */
class Delay extends Thread {
	long timeout=0;
	Event event;
	Component item;
	/**
	 * Delay() コンストラクタ
	 * @param paramLong
	 */
	public Delay(long paramLong) {
		try {
			Thread.sleep(this.timeout);
		} catch (InterruptedException localInterruptedException) {
		}
	}
	/**
	 * Delay() コンストラクタ
	 * @param paramLong
	 * @param paramEvent
	 * @param paramComponent
	 */
	public Delay(long paramLong, Event paramEvent, Component paramComponent) {
		this.timeout = paramLong;
		this.item = paramComponent;
		this.event = new Event(paramComponent, paramEvent.when, paramEvent.id, paramEvent.x, paramEvent.y,
				paramEvent.key, paramEvent.modifiers, paramComponent);
		start();
	}
	/**
	 * Delay() コンストラクタ
	 * @param paramLong
	 * @param paramInt
	 * @param paramComponent
	 */
	public Delay(long paramLong, int paramInt, Component paramComponent) {
		this.timeout = paramLong;
		this.item = paramComponent;
		this.event = new Event(paramComponent, 0L, 401, 0, 0, paramInt, 0, paramComponent);
		start();
	}
	@SuppressWarnings("deprecation")
	/**
	 * run() 
	 */
	public void run() {
		try {
			Thread.sleep(this.timeout);
		} catch (InterruptedException localInterruptedException) {
		}
		this.event.when = System.currentTimeMillis();
		this.item.handleEvent(this.event);
	}
}
/**
 * class Exclusive Exclusiveクラス
 * @author suzukiiichiro
 */
class Exclusive {
	int first = 0;
	int last = -1;
	/**
	 * add()
	 * @return
	 */
	synchronized int add() {
		return ++this.last;
	}
	/**
	 * leave()
	 */
	synchronized void leave() {
		this.first += 1;
	}
	/**
	 * enter()
	 */
	void enter() {
		int i = add();
		while (i != this.first) {
			new Delay(80L);
		}
	}
}
/**
 * class Cube Cubeクラス
 * @author suzukiiichiro
 */
class Cube extends Point3D {
	static Point3D[] vp = { new Point3D(0.0D, 0.0D, 0.0D), new Point3D(1.0D, 0.0D, 0.0D), new Point3D(0.0D, 1.0D, 0.0D),
			new Point3D(0.0D, 0.0D, 1.0D), new Point3D(1.0D, 1.0D, 0.0D), new Point3D(0.0D, 1.0D, 1.0D),
			new Point3D(1.0D, 0.0D, 1.0D), new Point3D(1.0D, 1.0D, 1.0D) };
	Point3D bp;
	Point3D[] v;
	Point3D[] vt;
	Point3D[] bv;
	Point[] p;
	Color[] c;
	boolean[] sw;
	/**
	 * Cube() コンストラクタ
	 * @param paramPoint3D
	 * @param paramArrayOfColor
	 */
	public Cube(Point3D paramPoint3D, Color[] paramArrayOfColor) {
		super(paramPoint3D);
		this.v = new Point3D[8];
		this.vt = new Point3D[8];
		this.bv = new Point3D[8];
		this.p = new Point[8];
		this.c = new Color[6];
		this.sw = new boolean[6];
		System.arraycopy(paramArrayOfColor, 0, this.c, 0, paramArrayOfColor.length);
		System.arraycopy(vp, 0, this.v, 0, vp.length);
		updateBase();
	}
	/**
	 * updateBase()
	 */
	public void updateBase() {
		this.bp = new Point3D(this);
		System.arraycopy(this.v, 0, this.bv, 0, this.v.length);
	}
	/**
	 * rotateX()
	 * @param paramDouble1
	 * @param paramDouble2
	 */
	public void rotateX(double paramDouble1, double paramDouble2) {
		for (int i = 1; i < 8; i++) {
			Point3D localPoint3D = this.bv[i];
			this.v[i] = new Point3D(localPoint3D.x, localPoint3D.y * paramDouble1 + localPoint3D.z * paramDouble2,
					localPoint3D.z * paramDouble1 - localPoint3D.y * paramDouble2);
		}
	}
	/**
	 * rotateY()
	 * @param paramDouble1
	 * @param paramDouble2
	 */
	public void rotateY(double paramDouble1, double paramDouble2) {
		for (int i = 1; i < 8; i++) {
			Point3D localPoint3D = this.bv[i];
			this.v[i] = new Point3D(localPoint3D.x * paramDouble1 - localPoint3D.z * paramDouble2, localPoint3D.y,
					localPoint3D.z * paramDouble1 + localPoint3D.x * paramDouble2);
		}
	}
	/**
	 * rotateZ()
	 * @param paramDouble1
	 * @param paramDouble2
	 */
	public void rotateZ(double paramDouble1, double paramDouble2) {
		for (int i = 1; i < 8; i++) {
			Point3D localPoint3D = this.bv[i];
			this.v[i] = new Point3D(localPoint3D.x * paramDouble1 + localPoint3D.y * paramDouble2,
					localPoint3D.y * paramDouble1 - localPoint3D.x * paramDouble2, localPoint3D.z);
		}
	}
	/**
	 * getDist()
	 * @param paramCoordinate
	 * @return
	 */
	public double getDist(Coordinate paramCoordinate) {
		Point3D localPoint3D1 = this.v[7].mul(0.5D);
		Point3D localPoint3D2 = sub(localPoint3D1);
		Point3D localPoint3D3 = localPoint3D2.sub(paramCoordinate);
		Point3D localPoint3D4 = add(localPoint3D1).sub(paramCoordinate);
		double d2 = localPoint3D3.dot();
		this.p[0] = paramCoordinate.Project(this.vt[0] = localPoint3D2).pt();
		int i;
		for (i = 1; i < 8; i++)
		// for (int i = 1; i < 8; i++)
		{
			this.p[i] = paramCoordinate.Project(this.vt[i] = localPoint3D2.add(this.v[i])).pt();
			double d1;
			if ((d1 = localPoint3D3.add(this.v[i]).dot()) > d2) {
				d2 = d1;
			}
		}
		i = 1;
		for (int j = 0; i < 4;) {
			// this.sw[(j++)] = (localPoint3D3.dot(this.v[i]) <= 0.0D ? 0 :
			// true);
			// <= 縺ッ
			this.sw[(j++)] = localPoint3D3.dot(this.v[i]) > 0.0D;
			// this.sw[(j++)] = (localPoint3D4.dot(this.v[(i++)]) >= 0.0D ? 0 :
			// true);
			this.sw[(j++)] = localPoint3D4.dot(this.v[(i++)]) < 0.0D;
		}
		return d2;
	}
	/**
	 * drawFace()
	 * @param paramGraphics
	 * @param paramArrayOfPoint
	 * @param paramInt1
	 * @param paramInt2
	 * @param paramInt3
	 * @param paramInt4
	 * @param paramInt5
	 */
	public void drawFace(Graphics paramGraphics, Point[] paramArrayOfPoint, int paramInt1, int paramInt2, int paramInt3,
			int paramInt4, int paramInt5) {
		int[] arrayOfInt1 = { paramArrayOfPoint[paramInt1].x, paramArrayOfPoint[paramInt2].x,
				paramArrayOfPoint[paramInt3].x, paramArrayOfPoint[paramInt4].x };
		int[] arrayOfInt2 = { paramArrayOfPoint[paramInt1].y, paramArrayOfPoint[paramInt2].y,
				paramArrayOfPoint[paramInt3].y, paramArrayOfPoint[paramInt4].y };
		paramGraphics.setColor(this.c[paramInt5]);
		paramGraphics.fillPolygon(arrayOfInt1, arrayOfInt2, 4);
	}
	/**
	 * draw()
	 * @param paramGraphics
	 * @param paramCoordinate
	 */
	public void draw(Graphics paramGraphics, Coordinate paramCoordinate) {
		// if (this.sw[0] != 0) {
		if (this.sw[0]) {
			drawFace(paramGraphics, this.p, 0, 3, 5, 2, 0);
		}
		// if (this.sw[1] != 0) {
		if (this.sw[1]) {
			drawFace(paramGraphics, this.p, 1, 4, 7, 6, 1);
		}
		// if (this.sw[2] != 0) {
		if (this.sw[2]) {
			drawFace(paramGraphics, this.p, 0, 1, 6, 3, 2);
		}
		if (this.sw[3]) {
			// if (this.sw[3] != 0) {
			drawFace(paramGraphics, this.p, 2, 5, 7, 4, 3);
		}
		if (this.sw[4]) {
			// if (this.sw[4] != 0) {
			drawFace(paramGraphics, this.p, 0, 2, 4, 1, 4);
		}
		if (this.sw[5]) {
			// if (this.sw[5] != 0) {
			drawFace(paramGraphics, this.p, 3, 6, 7, 5, 5);
		}
	}
	/**
	 * checkLine()
	 * @param paramPoint1
	 * @param paramPoint2
	 * @param paramPoint3
	 * @return
	 */
	public double checkLine(Point paramPoint1, Point paramPoint2, Point paramPoint3) {
		return (paramPoint1.x - paramPoint2.x) * (paramPoint3.y - paramPoint2.y)
				+ (paramPoint1.y - paramPoint2.y) * (paramPoint2.x - paramPoint3.x);
	}
	/**
	 * crossPoint()
	 * @param paramPoint3D1
	 * @param paramPoint3D2
	 * @param paramPoint3D3
	 * @param paramPoint3D4
	 * @param paramPoint3D5
	 * @return
	 */
	public Point3D crossPoint(Point3D paramPoint3D1, Point3D paramPoint3D2, Point3D paramPoint3D3,
			Point3D paramPoint3D4, Point3D paramPoint3D5) {
		Point3D localPoint3D1 = paramPoint3D2.sub(paramPoint3D1);
		Point3D localPoint3D2 = paramPoint3D4.sub(paramPoint3D3).cross(paramPoint3D5.sub(paramPoint3D4));
		return paramPoint3D1.add(localPoint3D1.mul((paramPoint3D3.dot(localPoint3D2) - paramPoint3D1.dot(localPoint3D2))
				/ localPoint3D1.dot(localPoint3D2)));
	}
	/**
	 * checkFace()
	 * @param paramPoint
	 * @param paramArrayOfPoint
	 * @param paramInt1
	 * @param paramInt2
	 * @param paramInt3
	 * @param paramInt4
	 * @param paramCoordinate
	 * @return
	 */
	public Point3D checkFace(Point paramPoint, Point[] paramArrayOfPoint, int paramInt1, int paramInt2, int paramInt3,
			int paramInt4, Coordinate paramCoordinate) {
		Point[] arrayOfPoint = { paramArrayOfPoint[paramInt1], paramArrayOfPoint[paramInt2],
				paramArrayOfPoint[paramInt3], paramArrayOfPoint[paramInt4], paramArrayOfPoint[paramInt1] };
		for (int i = 0; i < 4; i++) {
			if (checkLine(paramPoint, arrayOfPoint[i], arrayOfPoint[(i + 1)]) < 0.0D) {
				return null;
			}
		}
		return crossPoint(paramCoordinate, paramCoordinate.Prospect(new Point2D(paramPoint.x, paramPoint.y), 1.0F),
				this.vt[paramInt1], this.vt[paramInt2], this.vt[paramInt3]);
	}
	/**
	 * check() 
	 * @param paramPoint
	 * @param paramCoordinate
	 * @return
	 */
	public Point3D check(Point paramPoint, Coordinate paramCoordinate) {
		Point3D localPoint3D;
		// if ((this.sw[0] != 0) && ((localPoint3D = checkFace(paramPoint,
		// this.p, 0, 3, 5, 2, paramCoordinate)) != null)) {
		if ((this.sw[0]) && ((localPoint3D = checkFace(paramPoint, this.p, 0, 3, 5, 2, paramCoordinate)) != null)) {
			return localPoint3D;
		}
		// if ((this.sw[1] != 0) && ((localPoint3D = checkFace(paramPoint,
		// this.p, 1, 4, 7, 6, paramCoordinate)) != null)) {
		if ((this.sw[1]) && ((localPoint3D = checkFace(paramPoint, this.p, 1, 4, 7, 6, paramCoordinate)) != null)) {
			return localPoint3D;
		}
		// if ((this.sw[2] != 0) && ((localPoint3D = checkFace(paramPoint,
		// this.p, 0, 1, 6, 3, paramCoordinate)) != null)) {
		if ((this.sw[2]) && ((localPoint3D = checkFace(paramPoint, this.p, 0, 1, 6, 3, paramCoordinate)) != null)) {
			return localPoint3D;
		}
		// if ((this.sw[3] != 0) && ((localPoint3D = checkFace(paramPoint,
		// this.p, 2, 5, 7, 4, paramCoordinate)) != null)) {
		if ((this.sw[3]) && ((localPoint3D = checkFace(paramPoint, this.p, 2, 5, 7, 4, paramCoordinate)) != null)) {
			return localPoint3D;
		}
		// if ((this.sw[4] != 0) && ((localPoint3D = checkFace(paramPoint,
		// this.p, 0, 2, 4, 1, paramCoordinate)) != null)) {
		if ((this.sw[4]) && ((localPoint3D = checkFace(paramPoint, this.p, 0, 2, 4, 1, paramCoordinate)) != null)) {
			return localPoint3D;
		}
		// if ((this.sw[5] != 0) && ((localPoint3D = checkFace(paramPoint,
		// this.p, 3, 6, 7, 5, paramCoordinate)) != null)) {
		if ((this.sw[5]) && ((localPoint3D = checkFace(paramPoint, this.p, 3, 6, 7, 5, paramCoordinate)) != null)) {
			return localPoint3D;
		}
		return null;
	}
}
/**
 * class Canvas3D Canvas3Dクラス
 * @author suzukiiichiro
 */
class Canvas3D extends Canvas implements Setting {
	private static final long serialVersionUID = 1L;
	static int ID_DELAY = 65281;
	static long lastDrag;
	boolean active = true;
	long interval = 100L;
	long factor = 2L;
	long mfactor = 20L;
	long counter;
	int mode = -1;
	/**
	 * Canvas3D() コンストラクタ
	 */
	public Canvas3D() {
		setBackground(Setting.gray);
	}
	/**
	 * Canvas3D() コンストラクタ
	 * @param paramInt
	 */
	public Canvas3D(int paramInt) {
		this();
		this.mode = paramInt;
	}
	/**
	 * insets()
	 * @return
	 */
	public Insets insets() {
		return Setting.insets;
	}
	/**
	 * getMode()
	 * @return
	 */
	public int getMode() {
		return this.mode;
	}
	/**
	 * setMode()
	 * @param paramInt
	 * @return
	 */
	public boolean setMode(int paramInt) {
		if (this.mode == paramInt) {
			return false;
		}
		this.mode = paramInt;
		repaint();
		return true;
	}
	/**
	 * getActive()
	 * @return
	 */
	public boolean getActive() {
		return this.active;
	}
	/**
	 * setActive()
	 * @param paramBoolean
	 * @return
	 */
	public boolean setActive(boolean paramBoolean) {
		if (this.active == paramBoolean) {
			return false;
		}
		this.active = paramBoolean;
		repaint();
		return true;
	}
	/**
	 * Draw3DRect()
	 * @param paramGraphics
	 * @param paramInt
	 * @param paramColor
	 */
	public void Draw3DRect(Graphics paramGraphics, int paramInt, Color paramColor) {
		Draw3DRect(paramGraphics, 0, 0, getSize().width, getSize().height, paramInt, paramColor);
	}
	/**
	 * Draw3DRect()
	 * @param paramGraphics
	 * @param paramInt1
	 * @param paramInt2
	 * @param paramInt3
	 * @param paramInt4
	 * @param paramInt5
	 * @param paramColor
	 */
	static void Draw3DRect(Graphics paramGraphics, int paramInt1, int paramInt2, int paramInt3, int paramInt4,
			int paramInt5, Color paramColor) {
		Color localColor1;
		Color localColor2;
		if (paramInt5 > 0) {
			localColor1 = Setting.ltGray;
			localColor2 = Setting.dkGray;
		} else {
			localColor1 = Setting.dkGray;
			localColor2 = Setting.ltGray;
			paramInt5 = -paramInt5;
		}
		paramInt3 += paramInt1 - 1;
		paramInt4 += paramInt2 - 1;
		int i;
		for (i = 0; i < paramInt5; i++)
		// for (int i = 0; i < paramInt5; i++)
		{
			paramGraphics.setColor(localColor2);
			paramGraphics.drawLine(paramInt3 - i, paramInt4 - i, paramInt3 - i, paramInt2 + i);
			paramGraphics.drawLine(paramInt3 - i, paramInt4 - i, paramInt1 + i, paramInt4 - i);
			paramGraphics.setColor(localColor1);
			paramGraphics.drawLine(paramInt1 + i, paramInt2 + i, paramInt3 - i, paramInt2 + i);
			paramGraphics.drawLine(paramInt1 + i, paramInt2 + i, paramInt1 + i, paramInt4 - i);
		}
		if (paramColor != null) {
			paramInt3 -= paramInt1;
			paramInt4 -= paramInt2;
			paramGraphics.setColor(paramColor);
			paramGraphics.fillRect(paramInt1 + i, paramInt2 + i, paramInt3 - i - i + 1, paramInt4 - i - i + 1);
		}
	}
	/**
	 * repaint()
	 */
	public void repaint() {
		Graphics localGraphics = getGraphics();
		if (localGraphics == null) {
			return;
		}
		update(localGraphics);
		localGraphics.dispose();
	}
	/**
	 * paint()
	 */
	public void paint(Graphics paramGraphics) {
		update(paramGraphics);
	}
	/**
	 * update()
	 */
	public void update(Graphics paramGraphics) {
		if (paramGraphics == null) {
			return;
		}
		int i = getSize().width - 4;
		int j = getSize().height - 4;
		if (this.mode < 0) {
			Draw3DRect(paramGraphics, -2, null);
			paramGraphics.clipRect(2, 2, i, j);
		} else if (this.mode > 0) {
			Draw3DRect(paramGraphics, 2, null);
			paramGraphics.clipRect(2, 2, i, j);
		}
	}
	@SuppressWarnings("deprecation")
	/**
	 * Notify()
	 * @param paramEvent
	 * @param paramObject
	 */
	public void Notify(Event paramEvent, Object paramObject) {
		Container localContainer = getParent();
		while ((localContainer != null) && (!localContainer.action(paramEvent, paramObject))) {
			localContainer = localContainer.getParent();
		}
	}
	/**
	 * mouseDrag()
	 */
	public boolean mouseDrag(Event paramEvent, int paramInt1, int paramInt2) {
		long l1 = paramEvent.when - lastDrag;
		if ((this.counter++ % this.factor == 0L) || (l1 > this.interval)) {
			long l2 = System.currentTimeMillis();
			delayDrag(paramEvent, paramInt1, paramInt2);
			this.interval = ((this.interval + System.currentTimeMillis() - l2) / 2L);
			if (paramEvent.when - lastDrag < 100L) {
				this.mfactor = ((this.mfactor + l1) / 2L);
			}
			this.factor = ((this.factor + this.interval / this.mfactor) / 2L);
			if (this.factor == 0L) {
				this.factor = 1L;
			}
			this.counter = 1L;
		}
		lastDrag = paramEvent.when;
		return true;
	}
	public boolean delayDrag(Event paramEvent, int paramInt1, int paramInt2) {
		return true;
	}
}
/**
 * class Button3D Button3Dクラス
 * @author suzukiiichiro
 */
class Button3D extends Label3D {
	private static final long serialVersionUID = 1L;
	static final int NORMAL = 0;
	static final int LEFT = 1;
	static final int RIGHT = 2;
	static final int UP = 3;
	static final int DOWN = 4;
	static final int S_LEFT = 5;
	static final int S_RIGHT = 6;
	static final int S_UP = 7;
	static final int S_DOWN = 8;
	static final int CHECKBTN = 9;
	int type;
	boolean autoRepeat = true;
	boolean postAction = true;
	boolean pressed = false;
	boolean mousePressed = false;
	/**
	 * Button3D() コンストラクタ 
	 * @param paramString
	 */
	public Button3D(String paramString) {
		super(paramString);
		this.raise = true;
		this.mode = 1;
	}
	/**
	 * Button3D() コンストラクタ
	 * @param paramString
	 * @param paramBoolean
	 */
	public Button3D(String paramString, boolean paramBoolean) {
		this(paramString);
		setActive(paramBoolean);
	}
	/**
	 * Button3D() コンストラクタ
	 * @param paramInt
	 */
	public Button3D(int paramInt) {
		super("");
		this.raise = true;
		this.mode = 1;
		this.type = paramInt;
		this.postAction = ((paramInt == 0) || (this.type == 9));
	}
	/**
	 * Button3D() コンストラクタ
	 * @param paramInt
	 * @param paramString
	 */
	public Button3D(int paramInt, String paramString) {
		this(paramString);
		this.type = paramInt;
	}
	/**
	 * Button3D() コンストラクタ
	 * @param paramInt
	 * @param paramString
	 * @param paramBoolean
	 */
	public Button3D(int paramInt, String paramString, boolean paramBoolean) {
		this(paramString);
		this.type = paramInt;
		setActive(paramBoolean);
	}
	/**
	 * preferredSize()
	 */
	public Dimension preferredSize() {
		switch (this.type) {
			case 1:
			case 2:
			case 3:
			case 4:
				return new Dimension(this.base, this.base);
			case 5:
			case 6:
				return new Dimension(this.base / 2, this.base);
			case 7:
			case 8:
				return new Dimension(this.base, this.base / 2);
		}
		return new Dimension(this.base * this.ratio, this.base);
	}
	/**
	 * setType()
	 * @param paramInt
	 * @return
	 */
	public boolean setType(int paramInt) {
		if (this.type == paramInt) {
			return false;
		}
		this.type = paramInt;
		repaint();
		return true;
	}
	/**
	 * setMode()
	 */
	public boolean setMode(int paramInt) {
		if (this.mode == paramInt) {
			return false;
		}
		this.mode = paramInt;
		repaint();
		return true;
	}
	/**
	 * setState()
	 * @param paramBoolean
	 * @return
	 */
	public boolean setState(boolean paramBoolean) {
		if (this.pressed == paramBoolean) {
			return false;
		}
		this.pressed = paramBoolean;
		setMode(this.pressed ? -1 : 1);
		return true;
	}
	/**
	 * update()
	 */
	public void update(Graphics paramGraphics) {
		if (paramGraphics == null) {
			return;
		}
		int j = getSize().width - 1;
		int k = getSize().height - 1;
		int m = j / 2;
		int n = k / 2;
		Color localColor1;
		Color localColor2;
		if (!this.pressed) {
			localColor1 = Setting.ltGray;
			localColor2 = Setting.dkGray;
		} else {
			localColor1 = Setting.dkGray;
			localColor2 = Setting.ltGray;
		}
		int i;
		switch (this.type) {
			case 1:
			case 5:
				paramGraphics.setColor(getBackground());
				paramGraphics.fillRect(0, 0, getSize().width, getSize().height);
				for (i = 0; i < 2; i++) {
					paramGraphics.setColor(localColor2);
					paramGraphics.drawLine(j - i, i, j - i, k - i);
					paramGraphics.drawLine(i, n, j - i, k - i);
					paramGraphics.setColor(localColor1);
					paramGraphics.drawLine(i, n, j - i, i);
				}
				return;
			case 2:
			case 6:
				paramGraphics.setColor(getBackground());
				paramGraphics.fillRect(0, 0, getSize().width, getSize().height);
				for (i = 0; i < 2; i++) {
					paramGraphics.setColor(localColor1);
					paramGraphics.drawLine(j - i, n, i, i);
					paramGraphics.drawLine(i, i, i, k - i);
					paramGraphics.setColor(localColor2);
					paramGraphics.drawLine(j - i, n, i, k - i);
				}
				return;
			case 3:
			case 7:
				paramGraphics.setColor(getBackground());
				paramGraphics.fillRect(0, 0, getSize().width, getSize().height);
				for (i = 0; i < 2; i++) {
					paramGraphics.setColor(localColor2);
					paramGraphics.drawLine(i, k - i, j - i, k - i);
					paramGraphics.drawLine(m, i, j - i, k - i);
					paramGraphics.setColor(localColor1);
					paramGraphics.drawLine(m, i, i, k - i);
				}
				return;
			case 4:
			case 8:
				paramGraphics.setColor(getBackground());
				paramGraphics.fillRect(0, 0, getSize().width, getSize().height);
				for (i = 0; i < 2; i++) {
					paramGraphics.setColor(localColor1);
					paramGraphics.drawLine(m, k - i, i, i);
					paramGraphics.drawLine(i, i, j - i, i);
					paramGraphics.setColor(localColor2);
					paramGraphics.drawLine(m, k - i, j - i, i);
				}
				return;
		}
		super.update(paramGraphics);
	}
	/**
	 * keyDown()
	 */
	public boolean keyDown(Event paramEvent, int paramInt) {
		if (paramInt == -1) {
			if (this.pressed) {
				Notify(paramEvent, this);
				new Delay(100L, paramEvent, this);
			} else {
				paramEvent.id = 502;
				Notify(paramEvent, this);
			}
			return true;
		}
		return false;
	}
	/**
	 * mouseDown()
	 */
	public boolean mouseDown(Event paramEvent, int paramInt1, int paramInt2) {
		if (!getActive()) {
			return true;
		}
		this.mousePressed = true;
		if (!this.postAction) {
			Notify(paramEvent, this);
			if (this.autoRepeat) {
				new Delay(500L, -1, this);
			}
		}
		setState(true);
		return true;
	}
	/**
	 * mousueUp()
	 */
	public boolean mouseUp(Event paramEvent, int paramInt1, int paramInt2) {
		if (this.pressed) {
			if (this.type == 9) {
				setActive(false);
				this.pressed = false;
				this.mode = 1;
			} else {
				setState(false);
			}
			if (this.postAction) {
				Notify(paramEvent, this);
			}
		}
		this.mousePressed = false;
		return true;
	}
	/**
	 * mouseEnter() 
	 */
	public boolean mouseEnter(Event paramEvent, int paramInt1, int paramInt2) {
		if (this.mousePressed) {
			setState(true);
		}
		return true;
	}
	/**
	 * mouseExit()
	 */
	public boolean mouseExit(Event paramEvent, int paramInt1, int paramInt2) {
		if (this.mousePressed) {
			setState(false);
		}
		return true;
	}
}
/**
 * class Label3D Label3Dクラス
 * @author suzukiiichiro
 */
class Label3D extends Canvas3D {
	private static final long serialVersionUID = 1L;
	String text;
	int base = 22;
	int ratio = 2;
	boolean raise = false;
	boolean fill = true;
	/**
	 * Label3D() コンストラクタ
	 * @param paramString
	 */
	public Label3D(String paramString) {
		setFont(Setting.bfont);
		setForeground(Setting.black);
		this.text = paramString;
		this.ratio = ((this.text.length() + 1) / 2);
		if (this.ratio == 0) {
			this.ratio += 1;
		}
	}
	/**
	 * Label3D() コンストラクタ
	 * @param paramString
	 * @param paramInt
	 */
	public Label3D(String paramString, int paramInt) {
		this(paramString);
		this.mode = paramInt;
	}
	/**
	 * Label3D() コンストラクタ
	 * @param paramString
	 * @param paramInt
	 * @param paramBoolean
	 */
	public Label3D(String paramString, int paramInt, boolean paramBoolean) {
		this(paramString, paramInt);
		this.raise = paramBoolean;
	}
	/**
	 * getBase()
	 * @return
	 */
	public int getBase() {
		return this.base;
	}
	/**
	 * setBase()
	 * @param paramInt
	 */
	public void setBase(int paramInt) {
		this.base = paramInt;
	}
	/**
	 * getRatio()
	 * @return
	 */
	public int getRatio() {
		return this.ratio;
	}
	/**
	 * setRatio()
	 * @param paramInt
	 */
	public void setRatio(int paramInt) {
		this.ratio = paramInt;
	}
	/**
	 * getText()
	 * @return
	 */
	public String getText() {
		return this.text;
	}
	/**
	 * setText()
	 * @param paramString
	 * @return
	 */
	public boolean setText(String paramString) {
//		if (this.text == paramString) {
		if (this.text.equals(paramString)) {
			return false;
		}
		this.text = paramString;
		repaint();
		return true;
	}
	/**
	 * getRaise()
	 * @return
	 */
	public boolean getRaise() {
		return this.raise;
	}
	/**
	 * setRaise()
	 * @param paramBoolean
	 * @return
	 */
	public boolean setRaise(boolean paramBoolean) {
		if (this.raise == paramBoolean) {
			return false;
		}
		this.raise = paramBoolean;
		repaint();
		return true;
	}
	/**
	 * preferredSize()
	 */
	public Dimension preferredSize() {
		return new Dimension(this.base * this.ratio, this.base);
	}
	/**
	 * update()
	 */
	public void update(Graphics paramGraphics) {
		if (paramGraphics == null) {
			return;
		}
		int i = getSize().width - 4;
		int j = getSize().height - 4;
		Color localColor = this.fill ? getBackground() : null;
		if ((this.mode < 0) || ((this.mode != 0) && (!getActive()))) {
			Draw3DRect(paramGraphics, -2, localColor);
			paramGraphics.clipRect(2, 2, i, j);
		} else if (this.mode > 0) {
			Draw3DRect(paramGraphics, 2, localColor);
			paramGraphics.clipRect(2, 2, i, j);
		} else if (this.fill) {
			paramGraphics.setColor(localColor);
			paramGraphics.fillRect(0, 0, getSize().width, getSize().height);
		}
		if (this.text == null) {
			return;
		}
		FontMetrics localFontMetrics = paramGraphics.getFontMetrics();
		int k = (getSize().width - localFontMetrics.stringWidth(this.text)) / 2;
		int m = (getSize().height - localFontMetrics.getFont().getSize()) / 2;
		m += localFontMetrics.getFont().getSize() - localFontMetrics.getDescent();
		if (getActive()) {
			if (this.raise) {
				paramGraphics.setColor(Setting.ltGray);
				if (this.mode < 0) {
					paramGraphics.drawString(this.text, k - 1, m - 1);
				} else if (this.mode > 0) {
					paramGraphics.drawString(this.text, k + 1, m + 1);
				}
			}
			paramGraphics.setColor(getForeground());
		} else {
			paramGraphics.setColor(Color.blue);
		}
		paramGraphics.drawString(this.text, k, m);
	}
	/**
	 * mouseDown()
	 */
	public boolean mouseDown(Event paramEvent, int paramInt1, int paramInt2) {
		if (!getActive()) {
			return true;
		}
		Notify(paramEvent, this);
		return true;
	}
}
/**
 * class Panel3D Panel3Dクラス
 * @author suzukiiichiro
 */
class Panel3D extends Panel implements Setting {
	private static final long serialVersionUID = 1L;
	int mode = -1;
	int rinsets = 1;
	/**
	 * Panel3D() コンストラクタ
	 */
	public Panel3D() {
		setLayout(Setting.flow);
		setBackground(Setting.gray);
	}
	/**
	 * Panel3D() Panel3Dコンストラクタ
	 * @param paramInt
	 */
	public Panel3D(int paramInt) {
		this();
	}
	/**
	 * Panel3D() コンストラクタ
	 * @param paramInt1
	 * @param paramInt2
	 */
	public Panel3D(int paramInt1, int paramInt2) {
		this(paramInt1);
		this.rinsets = paramInt2;
	}
	/**
	 * insets()
	 */
	public Insets insets() {
		int i = this.rinsets * 2;
		return new Insets(i, i, i, i);
	}
	/**
	 * repaint()
	 */
	public void repaint() {
		Graphics localGraphics = getGraphics();
		if (localGraphics == null) {
			return;
		}
		update(localGraphics);
		localGraphics.dispose();
	}
	/**
	 * Draw3DRect()
	 * @param paramGraphics
	 * @param paramInt
	 * @param paramColor
	 */
	public void Draw3DRect(Graphics paramGraphics, int paramInt, Color paramColor) {
		Canvas3D.Draw3DRect(paramGraphics, 0, 0, getSize().width, getSize().height, paramInt, paramColor);
	}
	/**
	 * paint()
	 */
	public void paint(Graphics paramGraphics) {
		update(paramGraphics);
	}
	/**
	 * update()
	 */
	public void update(Graphics paramGraphics) {
		if (paramGraphics == null) {
			return;
		}
		validate();
		int i = getSize().width - 4;
		int j = getSize().height - 4;
		if (this.mode < 0) {
			Draw3DRect(paramGraphics, -2, null);
			paramGraphics.clipRect(2, 2, i, j);
		} else if (this.mode > 0) {
			Draw3DRect(paramGraphics, 2, null);
			paramGraphics.clipRect(2, 2, i, j);
		}
	}
	@SuppressWarnings("deprecation")
	/**
	 * Notify()
	 * @param paramEvent
	 * @param paramObject
	 */
	public void Notify(Event paramEvent, Object paramObject) {
		Container localContainer = getParent();
		while ((localContainer != null) && (!localContainer.action(paramEvent, paramObject))) {
			localContainer = localContainer.getParent();
		}
	}
}
/**
 * class Point2D Point2Dクラス
 * @author suzukiiichiro
 */
class Point2D {
	double x;
	double y;
	/**
	 * Point2D() コンストラクタ
	 */
	Point2D() {
		this.x = (this.y = 0.0D);
	}
	/**
	 * Point2D() コンストラクタ
	 * @param paramPoint2D
	 */
	Point2D(Point2D paramPoint2D) {
		setValue(paramPoint2D);
	}
	/**
	 * Point2D() コンストラクタ
	 * @param paramDouble1
	 * @param paramDouble2
	 */
	Point2D(double paramDouble1, double paramDouble2) {
		setValue(paramDouble1, paramDouble2);
	}
	/**
	 * pt()
	 * @return
	 */
	Point pt() {
		return new Point((int) this.x, (int) this.y);
	}
	/**
	 * setValue()
	 * @param paramPoint2D
	 */
	void setValue(Point2D paramPoint2D) {
		this.x = paramPoint2D.x;
		this.y = paramPoint2D.y;
	}
	/**
	 * setValue()
	 * @param paramDouble1
	 * @param paramDouble2
	 */
	void setValue(double paramDouble1, double paramDouble2) {
		this.x = paramDouble1;
		this.y = paramDouble2;
	}
	/**
	 * isEqual()
	 * @param paramPoint2D
	 * @return
	 */
	boolean isEqual(Point2D paramPoint2D) {
		return (this.x == paramPoint2D.x) && (this.y == paramPoint2D.y);
	}
	/**
	 * lessEqual()
	 * @param paramPoint2D
	 * @return
	 */
	boolean lessEqual(Point2D paramPoint2D) {
		return (this.x <= paramPoint2D.x) && (this.y <= paramPoint2D.y);
	}
	/**
	 * min()
	 * @param paramPoint2D
	 * @return
	 */
	Point2D min(Point2D paramPoint2D) {
		return new Point2D(Math.min(this.x, paramPoint2D.x), Math.min(this.y, paramPoint2D.y));
	}
	/**
	 * max()
	 * @param paramPoint2D
	 * @return
	 */
	Point2D max(Point2D paramPoint2D) {
		return new Point2D(Math.max(this.x, paramPoint2D.x), Math.max(this.y, paramPoint2D.y));
	}
	/**
	 * dot()
	 * @param paramPoint2D
	 * @return
	 */
	double dot(Point2D paramPoint2D) {
		return this.x * paramPoint2D.x + this.y * paramPoint2D.y;
	}
	/**
	 * dot()
	 * @return
	 */
	double dot() {
		return this.x * this.x + this.y * this.y;
	}
	/**
	 * add()
	 * @param paramPoint2D
	 * @return
	 */
	Point2D add(Point2D paramPoint2D) {
		return new Point2D(this.x + paramPoint2D.x, this.y + paramPoint2D.y);
	}
	/**
	 * sub()
	 * @param paramPoint2D
	 * @return
	 */
	Point2D sub(Point2D paramPoint2D) {
		return new Point2D(this.x - paramPoint2D.x, this.y - paramPoint2D.y);
	}
	/**
	 * add()
	 * @param paramDouble
	 * @return
	 */
	Point2D add(double paramDouble) {
		return new Point2D(this.x + paramDouble, this.y + paramDouble);
	}
	/**
	 * sub()
	 * @param paramDouble
	 * @return
	 */
	Point2D sub(double paramDouble) {
		return new Point2D(this.x - paramDouble, this.y - paramDouble);
	}
	/**
	 * mul()
	 * @param paramDouble
	 * @return
	 */
	Point2D mul(double paramDouble) {
		return new Point2D(this.x * paramDouble, this.y * paramDouble);
	}
	/**
	 * div()
	 * @param paramDouble
	 * @return
	 */
	Point2D div(double paramDouble) {
		return new Point2D(this.x / paramDouble, this.y / paramDouble);
	}
	/**
	 * addBy()
	 * @param paramPoint2D
	 */
	void addBy(Point2D paramPoint2D) {
		this.x += paramPoint2D.x;
		this.y += paramPoint2D.y;
	}
	/**
	 * subBy()
	 * @param paramPoint2D
	 */
	void subBy(Point2D paramPoint2D) {
		this.x -= paramPoint2D.x;
		this.y -= paramPoint2D.y;
	}
	/**
	 * addBy()
	 * @param paramDouble
	 */
	void addBy(double paramDouble) {
		this.x += paramDouble;
		this.y += paramDouble;
	}
	/**
	 * subBy()
	 * @param paramDouble
	 */
	void subBy(double paramDouble) {
		this.x -= paramDouble;
		this.y -= paramDouble;
	}
	/**
	 * bulBy()
	 * @param paramDouble
	 */
	void mulBy(double paramDouble) {
		this.x *= paramDouble;
		this.y *= paramDouble;
	}
	/**
	 * divBy()
	 * @param paramDouble
	 */
	void divBy(double paramDouble) {
		this.x /= paramDouble;
		this.y /= paramDouble;
	}
}
/**
 * class Point3D Point3Dクラス
 * @author suzukiiichiro
 */
class Point3D {
	double x;
	double y;
	double z;
	/**
	 * Point3D() コンストラクタ
	 */
	Point3D() {
		this.x = (this.y = this.z = 0.0D);
	}
	/**
	 * Point3D() コンストラクタ
	 * @param paramPoint3D
	 */
	Point3D(Point3D paramPoint3D) {
		setValue(paramPoint3D);
	}
	/**
	 * Point3Dコンストラクタ
	 * @param paramDouble1
	 * @param paramDouble2
	 * @param paramDouble3
	 */
	Point3D(double paramDouble1, double paramDouble2, double paramDouble3) {
		setValue(paramDouble1, paramDouble2, paramDouble3);
	}
	/**
	 * setValue()
	 * @param paramPoint3D
	 */
	void setValue(Point3D paramPoint3D) {
		this.x = paramPoint3D.x;
		this.y = paramPoint3D.y;
		this.z = paramPoint3D.z;
	}
	/**
	 * setValue()
	 * @param paramDouble1
	 * @param paramDouble2
	 * @param paramDouble3
	 */
	void setValue(double paramDouble1, double paramDouble2, double paramDouble3) {
		this.x = paramDouble1;
		this.y = paramDouble2;
		this.z = paramDouble3;
	}
	/**
	 * isEqual()
	 * @param paramPoint3D
	 * @return
	 */
	boolean isEqual(Point3D paramPoint3D) {
		return (this.x == paramPoint3D.x) && (this.y == paramPoint3D.y) && (this.z == paramPoint3D.z);
	}
	/**
	 * lessEqual()
	 * @param paramPoint3D
	 * @return
	 */
	boolean lessEqual(Point3D paramPoint3D) {
		return (this.x <= paramPoint3D.x) && (this.y <= paramPoint3D.y) && (this.z <= paramPoint3D.z);
	}
	/**
	 * min()
	 * @param paramPoint3D
	 * @return
	 */
	Point3D min(Point3D paramPoint3D) {
		return new Point3D(Math.min(this.x, paramPoint3D.x), Math.min(this.y, paramPoint3D.y),
				Math.min(this.z, paramPoint3D.z));
	}
	/**
	 * max()
	 * @param paramPoint3D
	 * @return
	 */
	Point3D max(Point3D paramPoint3D) {
		return new Point3D(Math.max(this.x, paramPoint3D.x), Math.max(this.y, paramPoint3D.y),
				Math.max(this.z, paramPoint3D.z));
	}
	/**
	 * dot()
	 * @param paramPoint3D
	 * @return
	 */
	double dot(Point3D paramPoint3D) {
		return this.x * paramPoint3D.x + this.y * paramPoint3D.y + this.z * paramPoint3D.z;
	}
	/**
	 * dot()
	 * @return
	 */
	double dot() {
		return this.x * this.x + this.y * this.y + this.z * this.z;
	}
	/**
	 * cross()
	 * @param paramPoint3D
	 * @return
	 */
	Point3D cross(Point3D paramPoint3D) {
		return new Point3D(this.y * paramPoint3D.z - this.z * paramPoint3D.y,
				this.z * paramPoint3D.x - this.x * paramPoint3D.z, this.x * paramPoint3D.y - this.y * paramPoint3D.x);
	}
	/**
	 * add()
	 * @param paramPoint3D
	 * @return
	 */
	Point3D add(Point3D paramPoint3D) {
		return new Point3D(this.x + paramPoint3D.x, this.y + paramPoint3D.y, this.z + paramPoint3D.z);
	}
	/**
	 * sub()
	 * @param paramPoint3D
	 * @return
	 */
	Point3D sub(Point3D paramPoint3D) {
		return new Point3D(this.x - paramPoint3D.x, this.y - paramPoint3D.y, this.z - paramPoint3D.z);
	}
	/**
	 * add()
	 * @param paramDouble
	 * @return
	 */
	Point3D add(double paramDouble) {
		return new Point3D(this.x + paramDouble, this.y + paramDouble, this.z + paramDouble);
	}
	/**
	 * sub()
	 * @param paramDouble
	 * @return
	 */
	Point3D sub(double paramDouble) {
		return new Point3D(this.x - paramDouble, this.y - paramDouble, this.z - paramDouble);
	}
	/**
	 * mul()
	 * @param paramDouble
	 * @return
	 */
	Point3D mul(double paramDouble) {
		return new Point3D(this.x * paramDouble, this.y * paramDouble, this.z * paramDouble);
	}
	/**
	 * div()
	 * @param paramDouble
	 * @return
	 */
	Point3D div(double paramDouble) {
		return new Point3D(this.x / paramDouble, this.y / paramDouble, this.z / paramDouble);
	}
	/**
	 * addBy()
	 * @param paramPoint3D
	 */
	void addBy(Point3D paramPoint3D) {
		this.x += paramPoint3D.x;
		this.y += paramPoint3D.y;
		this.z += paramPoint3D.z;
	}
	/**
	 * subBy()
	 * @param paramPoint3D
	 */
	void subBy(Point3D paramPoint3D) {
		this.x -= paramPoint3D.x;
		this.y -= paramPoint3D.y;
		this.z -= paramPoint3D.z;
	}
	/**
	 * addBy()
	 * @param paramDouble
	 */
	void addBy(double paramDouble) {
		this.x += paramDouble;
		this.y += paramDouble;
		this.z += paramDouble;
	}
	/**
	 * subBy()
	 * @param paramDouble
	 */
	void subBy(double paramDouble) {
		this.x -= paramDouble;
		this.y -= paramDouble;
		this.z -= paramDouble;
	}
	/**
	 * mulBy()
	 * @param paramDouble
	 */
	void mulBy(double paramDouble) {
		this.x *= paramDouble;
		this.y *= paramDouble;
		this.z *= paramDouble;
	}
	/**
	 * divBy()
	 * @param paramDouble
	 */
	void divBy(double paramDouble) {
		this.x /= paramDouble;
		this.y /= paramDouble;
		this.z /= paramDouble;
	}
}
