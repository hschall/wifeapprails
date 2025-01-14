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


                      <!-- Right-Aligned Links -->
        <ul class="navbar-nav ms-auto">
          <!-- User Dropdown -->
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle text-white" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
              <i class="fas fa-user me-1 "></i> User
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
              <li>
                <%= link_to "Edit User", edit_user_registration_path, class: "dropdown-item " %>
              </li>
              <li>
                <hr class="dropdown-divider">
              </li>
              <li>
                <%= button_to "Log Out", destroy_user_session_path, method: :delete, class: "dropdown-item text-danger" %>
              </li>
            </ul>
          </li>
        </ul>
