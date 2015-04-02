function set_event_table_handler(resource) {
	if (resource == 'countries') {
		$(".visited").each(function() { 
			$(this).click(function() {
				var checkbox = $(this)
				var checked = checkbox.is(":checked")
				$.post( "/countries/" + checkbox.attr("name") + "/update_visited", { visited: checked }, function(data, e, d) {
					if (data["status"] == "OK") {
						if (checked) {
							SimplePieChart.sets["Visited"] = parseInt(SimplePieChart.sets["Visited"]) + 1;
							SimplePieChart.sets["Not Visited"] = parseInt(SimplePieChart.sets["Not Visited"]) - 1;
						} else {
							SimplePieChart.sets["Visited"] = parseInt(SimplePieChart.sets["Visited"]) - 1;
							SimplePieChart.sets["Not Visited"] = parseInt(SimplePieChart.sets["Not Visited"]) + 1;
						}
						$('.simple_pie_chart').each(function() {
	    					SimplePieChart.initialize(this);
	  					});
					}
				})
			})		
		})
	} else if (resource == 'currencies') {
		$(".collected").each(function() { 
			$(this).click(function() {
				var checkbox = $(this)
				var checked = checkbox.is(":checked")
				$.post( "/currencies/" + checkbox.attr("name") + "/update_collected", { collected: checked }, function(data, e, d) {
					if (data["status"] == "OK") {
						if (checked) {
							SimplePieChart.sets["Collected"] = parseInt(SimplePieChart.sets["Collected"]) + 1;
							SimplePieChart.sets["Not Collected"] = parseInt(SimplePieChart.sets["Not Collected"]) - 1;
						} else {
							SimplePieChart.sets["Collected"] = parseInt(SimplePieChart.sets["Collected"]) - 1;
							SimplePieChart.sets["Not Collected"] = parseInt(SimplePieChart.sets["Not Collected"]) + 1;
						}
						$('.simple_pie_chart').each(function() {
	    					SimplePieChart.initialize(this);
	  					});
					}
				})
			})		
		})
	}
}

function set_event_handler(resource) {
	if (resource == 'countries') {
		$("#check_all").click(function(data) {
			$('#countries_table > tr > td > input.visited[type="checkbox"]').each(function(){
				var checkbox = $(this)
				if (!checkbox.is(":checked")) {
					checkbox.prop('checked', true)
				}
			})
		})

		$("#visit").click(function(data) {
			var names = $.map(
				$('#countries_table > tr > td > input:checked.visited[type="checkbox"]'), 
				function(element){ return $(element).attr('name') }
			)

			$.post("/countries/update_visited", {ids: names}, function(data) {
				var visited_num = parseInt(data["visited_num"]);
				SimplePieChart.sets["Visited"] = parseInt(SimplePieChart.sets["Visited"]) + visited_num;
				SimplePieChart.sets["Not Visited"] = parseInt(SimplePieChart.sets["Not Visited"]) - visited_num;
				$('.simple_pie_chart').each(function() {
					SimplePieChart.initialize(this);
				});
			})
		})
	} else if (resource == 'currencies') {
		$("#check_all").click(function(data) {
			$('#currencies_table > tr > td > input.collected[type="checkbox"]').each(function(){
				var checkbox = $(this)
				if (!checkbox.is(":checked")) {
					checkbox.prop('checked', true)
				}
			})
		})

		$("#collect").click(function(data) {
			var names = $.map(
				$('#currencies_table > tr > td > input:checked.collected[type="checkbox"]'), 
				function(element){ return $(element).attr('name') }
			)

			$.post("/currencies/update_collected", {ids: names}, function(data) {
				var visited_num = parseInt(data["visited_num"]);
				SimplePieChart.sets["Collected"] = parseInt(SimplePieChart.sets["Collected"]) + visited_num;
				SimplePieChart.sets["Not Collected"] = parseInt(SimplePieChart.sets["Not Collected"]) - visited_num;
				$('.simple_pie_chart').each(function() {
					SimplePieChart.initialize(this);
				});
			})
		})
	}
}
