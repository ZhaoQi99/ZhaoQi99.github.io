const e=require("fs"),s=require("del"),r=require("gulp"),i=require("gulp-concat"),c=require("gulp-uglify");r.task("clean",(async()=>{s(["*.min.js","!three.min.js"])})),r.task("scripts",(async()=>{e.readdirSync("src").forEach((e=>{const s=e.split(".")[0];return r.src([`src/${s}.js`,"lib/*.js"]).pipe(i(`${s}.min.js`)).pipe(c()).pipe(r.dest("./"))}))})),r.task("default",r.series("clean","scripts"));