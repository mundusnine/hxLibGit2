package libgit2;


import libgit2.externs.LibGit2;
#if cpp
import cpp.ConstStar;
import cpp.RawPointer;
import libgit2.externs.LibGit2.GitSignature;
#end

@:unreflective
class Signature extends Common {
    #if cpp
    private var pointer:RawPointer<GitSignature> = null;
    #end

    public function new(name:String = null, email:String = null) {
        super();
        #if cpp
        if (name != null && email != null) {
            var r = LibGit2.git_signature_now(RawPointer.addressOf(pointer), name, email);
            checkError(r);
        }
        #end
    }
    
    public var name(get, null):String;
    private function get_name():String {
        return #if cpp untyped __cpp__("{0}->name", pointer); #else "";#end
    }
    
    public var email(get, null):String;
    private function get_email():String {
        return #if cpp untyped __cpp__("{0}->email", pointer);#else "";#end
    }
    
    public var epochWhen(get, null):Int;
    private function get_epochWhen():Int {
        return #if cpp untyped __cpp__("(int) {0}->when.time", pointer);#else 0;#end
    }
    #if cpp 
    public override function free() {
        LibGit2.git_signature_free(pointer);
    }
    #end
}