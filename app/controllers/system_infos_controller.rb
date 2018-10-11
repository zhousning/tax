class SystemInfosController < ApplicationController
  def update
    @system_info = SystemInfo.find(params[:id])
    if @system_info.update(system_info_params)
      redirect_to tax_categories_path
    else
      render tax_categories_path
    end
  end

  private

    def system_info_params
      params.require(:system_info).permit(:version)
    end
end
