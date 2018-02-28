// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";
import $ from "jquery";
import "moment";
import "moment-timezone";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

// function addTimeBlock(start, end) {
// 	let task_id = parseInt($('#task-id')[0].innerHTML)

// 	let data = {
// 		time_block: {
// 			task_id: task_id,
// 			start: {
// 				year: start.year(),
// 				month: start.month(),
// 				day: start.day(),
// 				hour: start.hour(),
// 				minute: start.minute(),
// 			},
// 			end: {
// 				year: end.year(),
// 				month: end.month(),
// 				day: end.day(),
// 				hour: end.hour(),
// 				minute: end.minute(),
// 			},
// 		},
// 	};

// 	console.log(data);

// 	data = JSON.stringify(data);

// 	$.ajax(time_block_path, {
// 		method: "post",
// 		dataType: "json",
// 		contentType: "application/json; charset=UTF-8",
// 		data: data,
// 		success: (resp) => {$('#timeblock-error')[0].innerHTML = "Success!";},

// 	});
// }

function startStopTimeBlock(button, task_id, action) {

	//%{"params" => %{"action" => action, "task_id" => task_id}}
	let data = {
		params: {
			action: action,
			task_id: task_id,
		}
	}

	data = JSON.stringify(data);

	$.ajax(time_block_api_path + "/startstop", {
		method: "post",
		dataType: "json",
		contentType: "application/json; charset=UTF-8",
		data: data,
		success: (resp) => {location.reload()},
	});
}


function init() {
	if ($('.start-button')) {
		$('.start-button').click(function() {
		//this.data = "data";
		startStopTimeBlock(this, this.dataset.taskId, "start");
		});
	}

	if ($('.stop-button')) {
		$('.stop-button').click(function() {
		//this.data = "data";
		startStopTimeBlock(this, this.dataset.taskId, "stop");
		});
	}
}

$(init);
