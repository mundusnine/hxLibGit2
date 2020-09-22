let project = new Project('hxLibGit2');
let html5 = process.argv.indexOf("html5") >= 0 || process.argv.indexOf("debug-html5") >= 0;
if(html5){
    project.addAssets('libgit2-wasm/**');
}
project.addSources('src');
resolve(project);
