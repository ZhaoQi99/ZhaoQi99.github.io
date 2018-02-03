{#代码全选按钮#}
{% if page.date %}
<script>
$(document).ready(function () {
	var SelectText = function(element) {
		var doc = document
			, text = element
			, range, selection
		;
		if (doc.body.createTextRange) {
			range = document.body.createTextRange();
			range.moveToElementText(text);
			range.select();
		} else if (window.getSelection) {
			selection = window.getSelection();
			range = document.createRange();
			range.selectNodeContents(text);
			selection.removeAllRanges();
			selection.addRange(range);
		}
	};
	$(".code").each(function() {
		var code = $(this).get(0);
		var button_html =
			'<div style="position: fixed;'                                                               +
						'right: 3%;'                                                                     +
						'margin-top: 5px;'                                                               +
						'font-family: consolas, Menlo, \'PingFang SC\', \'Microsoft YaHei\', monospace;' +
						'font-size: 10px;'                                                               +
						'cursor: pointer;'                                                               +
						'color: #e31436;'                                                                +
						'">'                                                                             +
			'<span>全选</span>'                                                                          +
			'</div>';
		var button = $(button_html);
		$(button).click(function() {
			SelectText(code);
		});
		$(button).insertBefore(this);
	});
});
</script>
{% endif %}