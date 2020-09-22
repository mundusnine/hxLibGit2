package libgit2;


import libgit2.externs.LibGit2;
#if cpp
import libgit2.externs.LibGit2.GitRemote;
import cpp.RawPointer;
#end
@:unreflective
@:access(libgit2.Repository)
class Remote extends Common {
    #if cpp
    private var pointer:RawPointer<GitRemote> = null;
    #end
    
    public var repository:Repository;
    
    public function new(repository:Repository) {
        super();
        this.repository = repository;
    }
    #if cpp
    public function lookup(name:String) {
        var r = LibGit2.git_remote_lookup(RawPointer.addressOf(pointer), repository.pointer, name);
        checkError(r);
    }
    
    public function disconnect() {
        LibGit2.git_remote_disconnect(pointer);
    }
    
    public override function free() {
        LibGit2.git_remote_free(pointer);
    }
    #end
}