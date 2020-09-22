package libgit2;


import libgit2.externs.LibGit2;
#if cpp
import cpp.RawPointer;
#end

@:unreflective
@:access(libgit2.Repository)
@:access(libgit2.Oid)
class Tree extends Common {
    #if cpp
    private var pointer:RawPointer<GitTree> = null;
    #end

    public var repository:Repository;
    
    public function new(repository:Repository) {
        super();
        this.repository = repository;
    }
    #if cpp
    public function lookup(oid:Oid) {
        
        var r = LibGit2.git_tree_lookup(RawPointer.addressOf(pointer), repository.pointer, oid.pointer);
        checkError(r);
        
    }
    
    public override function free() {
        LibGit2.git_tree_free(pointer);
    }
    #end
}