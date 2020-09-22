package libgit2;

@:unreflective
class Common {
    public function new() {
        Lib.init();
    }
    #if cpp
    public function free() {
        throw "Must override";
    }
    #end
    private function checkError(e, throwException:Bool = true):Error {
        var error:Error = null;
        if (e < 0) {
            error = Lib.lastError;
            error.code = e;
            if (throwException == true) {
                throw error;
            }
        }
        return error;
    }
}
