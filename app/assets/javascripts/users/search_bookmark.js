$(function(){

	// var data = ['apple','apricot'];

	// var keyupStack = [];

	// // キーが押されて上がった時にイベント発火
	// $('#search').on('keyup', function(){
	// 	keyupStack.push(1); //配列の後ろに追加

	// 	//指定時間後に処理を実行させる
	// 	setTimeout(function(){
	// 		keyupStack.pop(); //配列の中身排出

	// 		//最後にkeyupされてから次の入力がなかった場合
	// 		if(keyupStack.length == 0){

	// 			$.ajax({
	// 				type: "GET",
	// 				url: "/apiurl",
	// 				data: {keyword : $('#search').val()}, //キーワードを送信してデータを検索しにいく
	// 			}).done(function(data){

	// 				//取得したデータを処理する(jsonを受け取る想定)
	// 				var test_len = Object.keys(data["test"]).length;
	// 				for(var i = 0; i < test_len; i++){
	// 					$('#test').append("<li>" + data["test"][i]["name"] + "</li>");
	// 				}

	// 			}).fail(function(data){
	// 				alert('failed');
	// 			});
	// 		}
	// 	});
	// });

	$(document).on('turbolinks:load',function(){

		// キーが押されて上がった時にイベント発火
		$(document).on('keyup','#search',function(e){
			e.preventDefault(); //キャンセル可能なイベントをキャンセル
			var input = $(this).val();
			var user_id = $('#user-id').text();
			alert(user_id);

			$.ajax({
			url: `/users/${user_id}/search`,
			type: 'GET',
			data: ('keyword=' + input),
			processData: false,
			contentType: false,
			dataType: 'json'
			})
			.done(function(data){
				$('#result').find('li').remove();
				$(data).each(function(i,bookmark){
					$('#result').append("<li>" + bookmark.service_name + "</li>")
				});
			}).fail(function(data){
				alert('failed');
			});
		});
	});
});