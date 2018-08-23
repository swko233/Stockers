// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require bootstrap-tagsinput.min

// ブラウザバック時にドロップダウンが開けなかったので対策
$(document).on('turbolinks:load',function(){
	// バリデーションエラー時の「必須」アイコンのずれ解消
	$(function(){
		$("div.field_with_errors:has(label)").addClass("parent");
	});
	// ヘッダーのドロップダウンメニュー開閉
	$(function(){
		//ドロップダウンを開く
		$('.user-menu').on('click', function(){
			// 閉じる処理で、メニュー非表示にしようとしてユーザー情報欄をクリックしてもイベントが起きなくなったので追記
			if ($('#dropdown-window').hasClass('is-active')){
				$('#dropdown-window').removeClass('is-active');
			}else{
				$('#dropdown-window').addClass('is-active');
			}
		});
		// ドロップダウンを閉じる
		$(document).on('click',function(e){
			// ドロップダウンメニューを表示させるためのクリックで発火するのを防ぐ（ユーザー情報欄を除外する）
			if (!$(e.target).is('.user-menu, .user-menu *, #dropdown-window, #dropdown-window *')){
				// alert();
				if ($('#dropdown-window').hasClass('is-active')){
					$('#dropdown-window').removeClass('is-active');
				}
			}
		});
	});
});
