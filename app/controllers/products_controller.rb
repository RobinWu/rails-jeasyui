class ProductsController < ApplicationController
  # GET /products
  # GET /products.xml
  def index
    @products_count = Product.where(build_conds).count
    @products = Product.where(build_conds).order("#{params[:sort]} #{params[:order]}").paginate(:per_page => params[:rows], :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
      format.json  {
        h = {:total => @products_count, :rows => @products.map{|i| {:id => i.id, :code => i.code, :name => i.name, :category => i.category.try(:name)}}}
        render :json => h.to_json
      }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end

  def build_conds
    conds = []; pars = {}
    unless params[:cid].blank?
      conds << "category_id = :cid"
      pars[:cid] = params[:cid]
    end
    unless params[:search].blank?
      conds << "(code LIKE :quick OR name LIKE :quick)"
      pars[:quick] = "%#{params[:search]}%"
    end

    [conds.join(' AND '), pars]
  end
end
