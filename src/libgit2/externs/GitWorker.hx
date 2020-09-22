package libgit2.externs;


#if kha_html5
import kha.Worker;
#elseif js
//@TODO: haxe will need to supply a way to use Webworkers for this to work
#end
@:native('Module')
extern class Lg2 {
    extern public function callMain(args:Array<String>):Void;
    extern public static dynamic function onRuntimeInitialized():Void;
    extern public dynamic function print(text:String):Void;
    extern public dynamic function printErr(text:String):Void;
}

extern enum abstract MountType(Dynamic) {
    var MEMFS;
    var NODEFS; 
    var IDBFS;
    var WORKERFS;
}

typedef Stats = {
    var isRoot:Bool;
    var exists:Bool;
    var error:Dynamic;
    var name:String;
    var path:String;
    var object:Dynamic;
    var parentExists:Bool;
    var parentPath:String;
    var parentObject:Dynamic;
};

typedef Options = {
    var ?encoding:String;
    var ?flags:String;
} 

//For more info look here: https://emscripten.org/docs/api_reference/Filesystem-API.html
@:native('FS')
extern class Fs{
    extern static public function mkdir(path:String):Void;
    extern static public function mount(type:MountType,options:Dynamic,mountpoint:String):Void;
    extern static public function writeFile(filepath:String,filecontents:String,?opts:Options):Void;
    extern static public function analyzePath(path:String, dontResolveLastLink:Bool=false):GitWorker.Stats;
    extern static public  function cwd():String;
    extern static public  function chdir(path:String):Void;
    extern static dynamic public function syncfs(populate:Bool,callback:Dynamic->Void):Void;
    extern static public function rename(oldpath:String, newpath:String):Void;
}
class GitWorker {
    static var lgPromise:Any;
    static var mounted:Bool = false;
    public static function main(): Void {
        #if kha_in_worker
        js.Syntax.code("importScripts(\"./lg2.js\")");
        lgPromise = new js.lib.Promise( 
            function(resolve,reject){
                Lg2.onRuntimeInitialized = function(){
                    var temp:Lg2 = js.Syntax.code("Module");
                    temp.print = function(text:String){
                        Worker.postFromWorker({info: text});
                    };
                    temp.printErr = function(text:String){
                        Worker.postFromWorker({error: text});
                    };
                    resolve(Lg2);
                };
            }        
        );
        var onmessage = js.Syntax.code("async function(args){
            var lg = await libgit2_externs_GitWorker.lgPromise;
            libgit2_externs_GitWorker.onMessage(lg,args);
        }");
        Worker.notifyWorker(onmessage);
        #end
    }
    static function onMessage(lg:Lg2,message:Dynamic){
        if(!mounted){
            Fs.mkdir('/repos');
            #if wasmfs
            Fs.mount(js.Syntax.code("MEMFS"), {}, '/repos');
            #else
            Fs.mount(js.Syntax.code("IDBFS"), {}, '/repos');
            #end
            Fs.chdir('/repos');
            Fs.syncfs(true,lg.printErr);//reload database
            mounted = true;
        }
        if(message.args[0] == "createDirOrCd"){
            var path:String = message.args[1];
            var stat:Stats = Fs.analyzePath(path);
            if(stat.error != null){
                lg.printErr(stat.error);
            }
            if(!stat.exists){
                Fs.mkdir(path);
            }
            Fs.chdir(path);
            Fs.syncfs(false,lg.printErr);
        }
        else if(message.args[0] == "NewUser"){
            var opts:Options = {flags: "w+"};//Overwrite
            Fs.writeFile(message.args[1],message.args[2],opts);
            Fs.syncfs(false,lg.printErr);
        }
        else if(message.args[0] == "fs"){
            switch(message.args[1]){
                case "writeFile":
                    Fs.writeFile(message.args[2],message.args[3]);
                    Fs.syncfs(false,lg.printErr);
            }   
        }
        else {
            lg.callMain(message.args);
        }
        
    }
}