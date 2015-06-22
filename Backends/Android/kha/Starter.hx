package kha;

import com.ktxsoftware.kha.KhaActivity;
import kha.graphics4.Graphics2;
import kha.android.Graphics;

/*class Starter {
	//static var instance : Starter;
	//static var game : Game;
	//static var painter : kha.android.Painter;
	
	public function new() {
		//instance = this;
		//kha.Loader.init(new kha.android.Loader());
	}
	
	public function start(game : Game) {
		//Starter.game = game;
		//Loader.getInstance().load();
	}
	
	public static function loadFinished() {
		//game.loadFinished();
	}
	
	public static var mouseX: Int;
	public static var mouseY: Int;
}*/

class Starter {
	public static var game: Game;
	private static var framebuffer: Framebuffer;
	private static var w: Int;
	private static var h: Int;
	public static var mouseX: Int = 0;
	public static var mouseY: Int = 0;
	
	public function new() {
		KhaActivity.the();
		new kha.input.Keyboard();
		new kha.input.Mouse();
		//gamepad = new Gamepad();
		
		Loader.init(new kha.android.Loader(KhaActivity.the().getApplicationContext()));
		Scheduler.init();
	}
	
	public function start(game: Game) {
		Starter.game = game;
		Configuration.setScreen(new EmptyScreen(Color.fromBytes(0, 0, 0)));
		Loader.the.loadProject(loadFinished);
	}
	
	public function loadFinished(): Void {
		Loader.the.initProject();
		game.width = Loader.the.width;
		game.height = Loader.the.height;
		Sys.init(w, h);
		
		var graphics = new Graphics();
		framebuffer = new Framebuffer(null, null, graphics);
		var g1 = new kha.graphics2.Graphics1(framebuffer);
		var g2 = new Graphics2(framebuffer);
		framebuffer.init(g1, g2, graphics);
		
		Scheduler.start();
		Configuration.setScreen(game);
		Configuration.screen().setInstance();
		game.loadFinished();
	}
	
	public static function init(width: Int, height: Int): Void {
		w = width;
		h = height;
		Main.main();
	}
	
	public static function setWidthHeight(width: Int, height: Int): Void {
		w = width;
		h = height;
	}
	
	public static function step(): Void {
		Scheduler.executeFrame();
		game.render(framebuffer);
	}
	
	public static function touch(index: Int, x: Int, y: Int, action: Int): Void {
		
	}
	
	public static function keyDown(code: Int): Void {
		
	}
	
	public static function keyUp(code: Int): Void {
		
	}
	
	public static function keyboardShown(): Bool {
		return false;
	}
}
