package libgit2;


import libgit2.externs.LibGit2;
#if cpp
import cpp.RawPointer;
import libgit2.externs.LibGit2.GitIndex;
#end
@:unreflective
@:access(libgit2.Oid)
class Index extends Common {
    #if cpp
    private var pointer:RawPointer<GitIndex> = null;
    #end
    public var repository:Repository;
    
    public function new(repository:Repository) {
        super();
        this.repository = repository;
    }
    #if cpp
    public function addPath(path:String) {
        
        var r = LibGit2.git_index_add_bypath(pointer, path);
        checkError(r);
        
    }
    
    public var treeOid(get, null):Oid;
    private function get_treeOid():Oid {
        var oid = new Oid();
        var r = LibGit2.git_index_write_tree(oid.pointer, pointer);
        checkError(r);
        return oid;
    }
    
    public var tree(get, null):Tree;
    private function get_tree():Tree {
        var t = new Tree(repository);
        t.lookup(treeOid);
        return t;
    }
    
    public override function free() {
        LibGit2.git_index_free(pointer);
    }
    #end
}