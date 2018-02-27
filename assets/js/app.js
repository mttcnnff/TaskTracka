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

const months = {
	January: 1,
	February: 2,
	March: 3,
	April: 4,
	May: 5,
	June: 6,
	July: 7,
	August: 8,
	

}

function getStartDate() {
	let year = $('#task_start_year')[0].selectedOptions[0].innerHTML;
	let month = $('#task_start_month')[0].selectedOptions[0].innerHTML;
	let day = $('#task_start_day')[0].selectedOptions[0].innerHTML;
	let hour = $('#task_start_hour')[0].selectedOptions[0].innerHTML;
	let minute = $('#task_start_minute')[0].selectedOptions[0].innerHTML;
	return moment().utc().year(year).month(month+1).date(day).hour(hour).minute(minute);
}

function getEndDate() {
	let year = $('#task_end_year')[0].selectedOptions[0].innerHTML;
	let month = $('#task_end_month')[0].selectedOptions[0].innerHTML;
	let day = $('#task_end_day')[0].selectedOptions[0].innerHTML;
	let hour = $('#task_end_hour')[0].selectedOptions[0].innerHTML;
	let minute = $('#task_end_minute')[0].selectedOptions[0].innerHTML;
	return moment().utc().year(year).month(month+1).date(day).hour(hour).minute(minute);
}

function addTimeBlock(start, end) {
	let task_id = parseInt($('#task-id')[0].innerHTML)

	let data = {
		time_block: {
			task_id: task_id,
			start: {
				year: start.year(),
				month: start.month(),
				day: start.day(),
				hour: start.hour(),
				minute: start.minute(),
			},
			end: {
				year: end.year(),
				month: end.month(),
				day: end.day(),
				hour: end.hour(),
				minute: end.minute(),
			},
		},
	};

	console.log(data);

	data = JSON.stringify(data);

	$.ajax(time_block_path, {
		method: "post",
		dataType: "json",
		contentType: "application/json; charset=UTF-8",
		data: data,
		success: (resp) => {$('#timeblock-error')[0].innerHTML = "Success!";},

	});
}


function init() {
	if (!$('.timeblock-button')) {
		return;
	}

	$('.timeblock-button').click(function() {
		let start = getStartDate();
		let end = getEndDate();
		if (start.isBefore(end)) {
			$('#timeblock-error')[0].innerHTML = "Submitted!";
			addTimeBlock(start, end);

		} else {
			$('#timeblock-error')[0].innerHTML = "Error: Start must be before End!";
		}
		return;
	});



}

$(init);
