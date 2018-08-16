$(function(){
	// 初期表示
	$('.change-content').hide();
	$('.change-content').eq(0).show(); //ブックマークを表示
	$('.change-tab-wrap').eq(0).addClass('is-active'); //ブックマークタブをアクティブに
	//クリックイベント
	$('.change-tab').each(function(){
		$(this).on('click', function(){
			// タブ表示切り替え
			var index = $('.change-tab').index(this); //コンテンツ番号に代入する
			$('.change-tab-wrap').removeClass('is-active');
			$(this).parent().addClass('is-active');
			// コンテンツ切り替え
			$('.change-content').hide();
			$('.change-content').eq(index).show();
		});
	});
});