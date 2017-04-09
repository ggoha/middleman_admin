class FilesController < ApplicationController
  def index
    @files = Dir.entries(StaticAdmin::ROOT)
  end

  def show
    @file_name = params[:id]
    @file = File.read "#{StaticAdmin::ROOT}/#{@file_name}"
  end 

  def update
    @file_name = params[:id]

    content = params[:file]

    File.open("#{StaticAdmin::ROOT}/#{@file_name}", 'w'){ |file| file.write content }   

    redirect_to root_path
  end

  def replace
    original_string = params[:find]
    replacement_string = params[:replace]
    if replacement_string.blank? or original_string.blank?
      flash[:warning] = "Отсутствуют строки"
      redirect_to root_path and return
    end     
    Dir.entries(StaticAdmin::ROOT).each do |file_name|
      abs_file = "#{StaticAdmin::ROOT}/#{file_name}"
      if File.file? abs_file
        text = File.read(abs_file)
        if text.include? original_string
          replace = text.gsub!(original_string, replacement_string)
          File.open(abs_file, "w") { |file| file.puts replace }
        end
      end
    end
    flash[:success] = "Успешно заменено"
    redirect_to root_path
  end

  def build
    p %x(cd #{StaticAdmin::ROOT} && bundle exec middleman build)
    flash[:success] = "Сайт успешно обновлен"
    redirect_to root_path 
  end
end
