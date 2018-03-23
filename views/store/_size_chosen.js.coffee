<% if !params[:color_chosen].present? %>
$("#colors_select").empty().append($('<option></option>').val("").html("Chọn màu"))

<% @colors.each do |color| %>

$("#colors_select").append('<option value="<%= color%>"><%= color %></option>')
$('#quantity').html('Hãy chọn size và màu sản phẩm')

<% end %>

<% else %>
<% @subproduct = @subproducts.where(["size = ? and color = ?", params[:size_chosen], params[:color_chosen]]).first %>
<% if @subproduct.quantity <= 0%>
$('#addtocart').attr("disabled", true)
$('#quantity').html('Đã hết hàng')
<% else %>
$('#addtocart').closest('form').attr("action", "<%=cart_items_path(subproduct_id: @subproduct.id)%>")
$('#addtocart').attr("disabled", false)
<% if @subproduct.quantity <= 2%>
$('#quantity').html('Cảnh báo! Còn lại ít hơn 2 sản phẩm. <a target="_blank" href="/static_pages/policy#canh-bao-so-luong">Tìm hiểu thêm.<a>')
<% else %>
$('#quantity').html('Chi còn <%= @subproduct.quantity %> sản phẩm')
<% if @subproduct.quantity > 5%>
$('#quantity').html('')
<% end %>
<% end %>
<% end %>
<% end %>