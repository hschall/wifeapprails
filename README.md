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


 <!-- Left-Aligned Links -->
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <% if current_user.admin? %>
            <!-- Admin Management Link -->
            <li class="nav-item">
              <%= link_to "User Management", admin_users_path, class: "nav-link text-white" %>
            </li>
          <% end %>
        </ul>