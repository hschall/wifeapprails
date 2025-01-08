# GitHub Test 1

  <!-- Toggle Between Views -->
    <div class="row mb-3">
    <div class="col-md-6 mx-auto text-center">
      <% if params[:master] %>
        <%= link_to "View My Records", records_path, class: "btn btn-secondary" %>
      <% else %>
        <%= link_to "View All Users' Records", records_path(master: true), class: "btn btn-primary" %>
      <% end %>
    </div>
  </div>
