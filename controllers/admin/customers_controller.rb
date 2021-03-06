class Admin::CustomersController < ApplicationController

    before_action :confirm_logged_in
  
    def index
    end
  
    def search
      @customers = Customer.search(params[:customer_search]).sorted
      if @customers.blank?
        flash[:notice] = "No match found"
      else
        flash[:notice] = nil
      end
    end
  
    def letter
      @customers = Customer.letter(params[:first_letter])
      if @customers.blank?
        flash[:notice] = "No match for this letter"
      else
        flash[:notice] = nil
      end    
    end
  
    def show
      @customer = Customer.find(params[:id])
       # [:id] is rails default, not database primary key [:customer_id]
      @address = @customer.address.address
      @city = @customer.address.city.city
      @district = @customer.address.district
      @zip_code = @customer.address.postal_code
      @country = @customer.address.city.country.country
    end
  
    def new
      @customer = Customer.new
      @address = @customer.build_address
    end
  
    def create
      @customer = Customer.new(customer_params)
      if @customer.save
      # if Customer.create(customer_params)
        flash[:notice] = "New Customer '#{@customer.full_name}' created."
        redirect_to(admin_customers_path)
      else
        render('new')
      end
    end
  
    def edit
      @customer = Customer.find(params[:id])
      # @address = Address.all
      @address = @customer.address
      @new_address_id = Address.all.count + 1
    end
  
    def update
      @customer = Customer.find(params[:id])
      #update
      if @customer.update_attributes(customer_params)
        flash[:notice] = "Customer '#{@customer.full_name}' updated."
        redirect_to(admin_customer_path(@customer))
      else
        render('edit')
      end    
    end
  
    def delete
      @customer = Customer.find(params[:id])
    end
  
    def destroy
      @customer = Customer.find(params[:id])
      @customer.destroy
      flash[:notice] = "Customer '#{@customer.full_name}' deleted."
      redirect_to(admin_customers_path)
    end
  
    private
      def customer_params
        params.require(:customer).permit(:first_name, :last_name, :store_id, :address_id, 
          :address_attributes => [:address, :address2, :district, :city_id, :postal_code, :phone])
      end
  end
  