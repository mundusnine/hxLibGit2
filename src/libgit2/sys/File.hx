package libgit2.sys;

#if js
import libgit2.externs.LibGit2;

class File {
    public static function saveContent(path:String, content:String):Void{
        LibGit2.call("fs","writeFile",path,content);
    }
}
#else
typedef File = sys.io.File;
#end