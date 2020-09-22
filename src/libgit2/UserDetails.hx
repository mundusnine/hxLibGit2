package libgit2;

import libgit2.externs.LibGit2;

class UserDetails {
    public var name:String;
    public var email:String;
    public var username:String;
    public var password:String;
    
    public function new(name:String, email:String, password:String) {
        this.name = name;
        this.email = email;
        this.username = email;
        this.password = password;
        #if js
        LibGit2.call("NewUser",'/home/web_user/.gitconfig','[user]\n' +'name = $name\n' +'email = $email');
        #end
    }
    
    public var signature(get, null):Signature;
    private function get_signature():Signature {
        return new Signature(name, email);
    }
}