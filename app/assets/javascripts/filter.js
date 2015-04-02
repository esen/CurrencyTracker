function update_table(resource, filter_value) {
	$.get(resource + "/search/", {filter_value: filter_value}, function(data, e, v) {
		$("#" + resource + "_table").html(data)
		set_event_table_handler(resource)
	})
}

$(document).ready(function() {
	if ($("#countries_table").length > 0) {
		resource = "countries"
	} else if ($("#currencies_table").length > 0) {
		resource = "currencies"
	} else {
		resource = false
	}
	if (resource) {
		set_event_handler(resource)
		update_table(resource, "")
		$("#submit_filter").click(function() {
			update_table(resource, $("#filter").val())
		})
	}
})