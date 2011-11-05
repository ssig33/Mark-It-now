// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
var mode = "landscape"
var cached = {}
var size = window_size()

function is_NaN($value){
  return (typeof $value == 'number' && $value.toString() == 'NaN');
}

function _id(){
  return $("#id").text()
}

function now(){
  var count = parseInt($("#now").text())
  if(is_NaN(count)){
    return 0
  }else{
    return count
  }
}
function _now(str){
  return $("#now").text(str)
}
function is_left(){
  return $("#is_left").text() === "true"
}

function width() {
        if ( window.innerWidth ) {
                return window.innerWidth;
        }
        else if ( document.documentElement && document.documentElement.clientWidth != 0 ) {
                return document.documentElement.clientWidth;
        }
        else if ( document.body ) {
                return document.body.clientWidth;
        }
        return 0;
}

function height() {
        if ( window.innerHeight ) {
                return window.innerHeight;
        }
        else if ( document.documentElement && document.documentElement.clientHeight != 0 ) {
                return document.documentElement.clientHeight;
        }
        else if ( document.body ) {
                return document.body.clientHeight;
        }
        return 0;
}

function is_portlait(){
  return (height()/width())<1
}
function window_size(){
  return {height: height(), width: width()}
}
