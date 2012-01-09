package com.ktxsoftware.kha.backends.flash;

import com.ktxsoftware.kha.Starter;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

class Loader extends com.ktxsoftware.kha.Loader {
	var xmlName : String;
	var main : Starter;
	var numberOfFiles : Int;
	
	public function new(main : Starter) {
		super();
		this.main = main;
	}
	
	private override function loadStarted(numberOfFiles : Int) {
		this.numberOfFiles = numberOfFiles;
	}
	
	public override function loadDataDefinition() {
		loadDataXml();
	}
	
	override function loadMusic(filename : String) {
		var urlRequest : URLRequest = new URLRequest(filename + ".mp3");
		var music : flash.media.Sound = new flash.media.Sound();
		music.addEventListener(Event.COMPLETE, function(e : Event) {
			musics.set(filename, new Music(music));
			--numberOfFiles;
			checkComplete();
		});
		music.load(urlRequest);
	}
	
	override function loadXml(filename : String) {
		var urlRequest : URLRequest = new URLRequest(filename);
		var urlLoader : URLLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, function(e : Event) {
			--numberOfFiles;
			checkComplete();
		});
		urlLoader.load(urlRequest);
	}
	
	override function loadImage(filename : String) {
		var urlRequest : URLRequest = new URLRequest(filename);
		var loader : flash.display.Loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event) {
			images.set(filename, new Image(loader.content));
			--numberOfFiles;
			checkComplete();
		});
		loader.load(urlRequest);
	}
	
	override function loadMap(name : String) {
		var urlRequest : URLRequest = new URLRequest(name);
		var urlLoader : URLLoader = new URLLoader();
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		urlLoader.addEventListener(Event.COMPLETE, function(e : Event) {
			var data : ByteArray = urlLoader.data;
			var levelWidth : Int = 40;// data.readInt();
			var levelHeight : Int = 32;// data.readInt();
			var map : Array<Array<Int>> = new Array<Array<Int>>();
			for (x in 0...levelWidth) {
				map.push(new Array<Int>());
				for (y in 0...levelHeight) {
					map[x].push(0); //data.readByte());// .readInt());
				}
			}
			for (y in 0...levelHeight) {
				for (x in 0...levelWidth) {
					map[x][y] = data.readByte();
				}
			}
			maps.set(name, map);
			--numberOfFiles;
			checkComplete();
		});
		urlLoader.load(urlRequest);
	}

	override function loadSound(filename : String) {
		var urlRequest : URLRequest = new URLRequest(filename + ".mp3");
		var sound : flash.media.Sound = new flash.media.Sound();
		sound.addEventListener(Event.COMPLETE, function(e : Event) {
			sounds.set(filename, new Sound(sound));
			--numberOfFiles;
			checkComplete();
		});
		sound.load(urlRequest);
	}
	
	function loadDataXml() : Void {
		var urlRequest : URLRequest = new URLRequest("data.xml");
		var urlLoader : URLLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, function(e : Event) {
			xmls.set("data.xml", Xml.parse(urlLoader.data));
			loadFiles();
		});
		urlLoader.load(urlRequest);
	}
	
	function checkComplete() {
		if (numberOfFiles <= 0) {
			main.loadFinished();
		}
	}
}