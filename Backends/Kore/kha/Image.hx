package kha;

import haxe.io.Bytes;
import kha.kore.graphics4.TextureUnit;
import kha.graphics4.TextureFormat;
import kha.graphics4.DepthStencilFormat;
import kha.graphics4.Usage;

@:headerCode('
#include <Kore/pch.h>
#include <Kore/Graphics/Graphics.h>
')

@:headerClassCode("Kore::Texture* texture; Kore::RenderTarget* renderTarget;")
class Image implements Canvas implements Resource {
	private var format: TextureFormat;
	private var readable: Bool;

	private var graphics1: kha.graphics1.Graphics;
	private var graphics2: kha.graphics2.Graphics;
	private var graphics4: kha.graphics4.Graphics;

	public static function createFromVideo(video: Video): Image {
		var image = new Image(false);
		image.format = TextureFormat.RGBA32;
		image.initVideo(cast(video, kha.kore.Video));
		return image;
	}

	public static function create(width: Int, height: Int, format: TextureFormat = null, usage: Usage = null): Image {
		return create2(width, height, format == null ? TextureFormat.RGBA32 : format, false, false, NoDepthAndStencil, 0);
	}

	public static function create3D(width: Int, height: Int, depth: Int, format: TextureFormat = null, usage: Usage = null): Image {
		return create3(width, height, depth, format == null ? TextureFormat.RGBA32 : format, false, 0);
	}

	public static function createRenderTarget(width: Int, height: Int, format: TextureFormat = null, depthStencil: DepthStencilFormat = NoDepthAndStencil, antiAliasingSamples: Int = 1, contextId: Int = 0): Image {
		return create2(width, height, format == null ? TextureFormat.RGBA32 : format, false, true, depthStencil, contextId);
	}
	
	public static function fromBytes(bytes: Bytes, width: Int, height: Int, format: TextureFormat = null, usage: Usage = null): Image {
		return null;
	}

	private function new(readable: Bool) {
		this.readable = readable;
	}

	private static function getRenderTargetFormat(format: TextureFormat): Int {
		switch (format) {
		case RGBA32:	// Target32Bit
			return 0;
		case RGBA64:	// Target64BitFloat
			return 1;
		case RGBA128:	// Target128BitFloat
			return 3;
		case DEPTH16:	// Target16BitDepth
			return 4;
		default:
			return 0;
		}
	}

	private static function getDepthBufferBits(depthAndStencil: DepthStencilFormat): Int {
		return switch (depthAndStencil) {
			case NoDepthAndStencil: -1;
			case DepthOnly: 24;
			case DepthAutoStencilAuto: 24;
			case Depth24Stencil8: 24;
			case Depth32Stencil8: 32;
		}
	}

	private static function getStencilBufferBits(depthAndStencil: DepthStencilFormat): Int {
		return switch (depthAndStencil) {
			case NoDepthAndStencil: -1;
			case DepthOnly: -1;
			case DepthAutoStencilAuto: 8;
			case Depth24Stencil8: 8;
			case Depth32Stencil8: 8;
		}
	}
	
	private static function getTextureFormat(format: TextureFormat): Int {
		switch (format) {
			case RGBA32:
				return 0;
			case RGBA128:
				return 3;
			default:
				return 1;
		}
	}

	public static function create2(width: Int, height: Int, format: TextureFormat, readable: Bool, renderTarget: Bool, depthStencil: DepthStencilFormat, contextId: Int): Image {
		var image = new Image(readable);
		image.format = format;
		if (renderTarget) image.initRenderTarget(width, height, getDepthBufferBits(depthStencil), getRenderTargetFormat(format), getStencilBufferBits(depthStencil), contextId);
		else image.init(width, height, getTextureFormat(format));
		return image;
	}

	public static function create3(width: Int, height: Int, depth: Int, format: TextureFormat, readable: Bool, contextId: Int): Image {
		var image = new Image(readable);
		image.format = format;
		image.init3D(width, height, depth, getTextureFormat(format));
		return image;
	}

	@:functionCode('renderTarget = new Kore::RenderTarget(width, height, depthBufferBits, false, (Kore::RenderTargetFormat)format, stencilBufferBits, contextId); texture = nullptr;')
	private function initRenderTarget(width: Int, height: Int, depthBufferBits: Int, format: Int, stencilBufferBits: Int, contextId: Int): Void {

	}

	@:functionCode('texture = new Kore::Texture(width, height, (Kore::Image::Format)format, readable); renderTarget = nullptr;')
	private function init(width: Int, height: Int, format: Int): Void {

	}

	@:functionCode('texture = new Kore::Texture(width, height, depth, (Kore::Image::Format)format, readable); renderTarget = nullptr;')
	private function init3D(width: Int, height: Int, depth:Int, format: Int): Void {

	}

	@:functionCode('texture = video->video->currentImage(); renderTarget = nullptr;')
	private function initVideo(video: kha.kore.Video): Void {

	}

	public static function fromFile(filename: String, readable: Bool): Image {
		var image = new Image(readable);
		var isFloat = StringTools.endsWith(filename, ".hdr");
		image.format = isFloat ? TextureFormat.RGBA128 : TextureFormat.RGBA32;
		image.initFromFile(filename);
		return image;
	}

	@:functionCode('texture = new Kore::Texture(filename.c_str(), readable);')
	private function initFromFile(filename: String): Void {

	}

	public var g1(get, null): kha.graphics1.Graphics;

	private function get_g1(): kha.graphics1.Graphics {
		if (graphics1 == null) {
			graphics1 = new kha.graphics2.Graphics1(this);
		}
		return graphics1;
	}

	public var g2(get, null): kha.graphics2.Graphics;

	private function get_g2(): kha.graphics2.Graphics {
		if (graphics2 == null) {
			graphics2 = new kha.kore.graphics4.Graphics2(this);
		}
		return graphics2;
	}

	public var g4(get, null): kha.graphics4.Graphics;

	private function get_g4(): kha.graphics4.Graphics {
		if (graphics4 == null) {
			graphics4 = new kha.kore.graphics4.Graphics(this);
		}
		return graphics4;
	}

	public static var maxSize(get, null): Int;

	public static function get_maxSize(): Int {
		return 4096;
	}

	public static var nonPow2Supported(get, null): Bool;

	@:functionCode('return Kore::Graphics::nonPow2TexturesSupported();')
	public static function get_nonPow2Supported(): Bool {
		return false;
	}

	public var width(get, null): Int;
	public var height(get, null): Int;
	public var depth(get, null): Int;

	@:functionCode("if (texture != nullptr) return texture->width; else return renderTarget->width;")
	public function get_width(): Int {
		return 0;
	}

	@:functionCode("if (texture != nullptr) return texture->height; else return renderTarget->height;")
	public function get_height(): Int {
		return 0;
	}

	@:functionCode("if (texture != nullptr) return texture->depth; else return 0;")
	public function get_depth(): Int {
		return 0;
	}

	public var realWidth(get, null): Int;
	public var realHeight(get, null): Int;

	@:functionCode("if (texture != nullptr) return texture->texWidth; else return renderTarget->texWidth;")
	public function get_realWidth(): Int {
		return 0;
	}

	@:functionCode("if (texture != nullptr) return texture->texHeight; else return renderTarget->texHeight;")
	public function get_realHeight(): Int {
		return 0;
	}

	@:functionCode("return (texture->at(x, y) & 0xff) != 0;")
	public function isOpaque(x: Int, y: Int): Bool {
		return true;
	}

	@:functionCode('return texture->at(x, y);')
	private function atInternal(x: Int, y: Int): Int {
		return 0;
	}

	public inline function at(x: Int, y: Int): Color {
		return Color.fromValue(atInternal(x, y));
	}

	@:functionCode("delete texture; texture = nullptr; delete renderTarget; renderTarget = nullptr;")
	public function unload(): Void {

	}

	private var bytes: Bytes = null;

	@:functionCode('
		int size = texture-> sizeOf(texture->format) * texture->width * texture->height;
		this->bytes = ::haxe::io::Bytes_obj::alloc(size);
		return this->bytes;
	')
	public function lock(level: Int = 0): Bytes {
		return null;
	}

	@:functionCode('
		Kore::u8* b = bytes->b->Pointer();
		Kore::u8* tex = texture->lock();
		int size = texture->sizeOf(texture->format);
		int stride = texture->stride();
		for (int y = 0; y < texture->height; ++y) {
			for (int x = 0; x < texture->width; ++x) {
#ifdef DIRECT3D
				if (texture->format == Kore::Image::RGBA32) {
					//RBGA->BGRA
					tex[y * stride + x * size + 0] = b[(y * texture->width + x) * size + 2];
					tex[y * stride + x * size + 1] = b[(y * texture->width + x) * size + 1];
					tex[y * stride + x * size + 2] = b[(y * texture->width + x) * size + 0];
					tex[y * stride + x * size + 3] = b[(y * texture->width + x) * size + 3];
				}
				else
#endif
				{
					for (int i = 0; i < size; ++i) {
						tex[y * stride + x * size + i] = b[(y * texture->width + x) * size + i];
					}
				}
			}
		}
		texture->unlock();
	')
	public function unlock(): Void {
		bytes = null;
	}

	public function generateMipmaps(levels: Int): Void {
		untyped __cpp__("texture->generateMipmaps(levels)");
	}

	public function setMipmaps(mipmaps: Array<Image>): Void {
		for (i in 0...mipmaps.length) {
			var image = mipmaps[i];
			var level = i + 1;
			untyped __cpp__("texture->setMipmap(image->texture, level)");
		}
	}

	public function setDepthStencilFrom(image: Image): Void {
		untyped __cpp__("renderTarget->setDepthStencilFrom(image->renderTarget)");
	}
}
