// $(function(){

// 	$(document).on('turbolinks:load',function(){

// 		// キーが押されて上がった時にイベント発火
// 		$(document).on('keyup','#search',function(e){
// 			e.preventDefault(); //キャンセル可能なイベントをキャンセル
// 			var input = $(this).val();
// 			var user_id = $('#user-id').text();

// 			$.ajax({
// 			url: `/users/${user_id}/search`,
// 			type: 'GET',
// 			data: ('keyword=' + input),
// 			processData: false,
// 			contentType: false,
// 			dataType: 'json'
// 			})
// 			.done(function(data){
// 				$('#result').find('li').remove();
// 				$(data).each(function(i,bookmark){
// 					$('#result').append("<li>" + bookmark.service_name + "</li>")
// 				});
// 			}).fail(function(data){
// 				alert('failed');
// 			});
// 		});
// 	});
// });