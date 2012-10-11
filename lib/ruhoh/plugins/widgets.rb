module Ruhoh::Plugins
  class Widgets < Base

    WidgetStructure = Struct.new(
      :name,
      :config,
      :javascripts,
      :layout
    )

    # Process available widgets into widget dictionary.
    #
    # Returns Dictionary of widget data.
    def generate
      widgets = {}
      self.widgets.each do |name|
        config = self.process_config(name)
        widgets[name] = WidgetStructure.new(
          name,
          config,
          self.process_javascripts(config, name),
          self.process_layout(config, name)
        )
      end
      Ruhoh::Utils.report('Widgets', widgets, [])

      widgets
    end

    # Find the widgets.
    #
    # Returns Array of widget names.
    def widgets
      names = []
      if FileTest.directory?(@ruhoh.paths.widgets)
        FileUtils.cd(@ruhoh.paths.widgets) { names += Dir["*"] }
      end
      if FileTest.directory?(@ruhoh.paths.system_widgets)
        FileUtils.cd(@ruhoh.paths.system_widgets) { names += Dir["*"] }
      end
      names.uniq!
      names
    end
    
    # Process the widget configuration params.
    #
    # Returns Hash of configuration params.
    def process_config(widget_name)
      system_config = Ruhoh::Utils.parse_yaml_file(@ruhoh.paths.system_widgets, widget_name, Ruhoh.names.config_data) || {}
      user_config = Ruhoh::Utils.parse_yaml_file(@ruhoh.paths.widgets, widget_name, Ruhoh.names.config_data) || {}
      config = Ruhoh::Utils.deep_merge(system_config, user_config)
      config['layout'] ||= widget_name
      config['stylesheet'] ||= widget_name
      config
    end
    
    # Process widget script dependencies.
    # Script dependencies may be set in the config.
    # Look for default script at: scripts/{widget_name}.js if no config.
    # If found, we include it, else no javascripts will load.
    #
    # Returns Array of script filenames to load.
    def process_javascripts(config, widget_name)
      scripts = config[Ruhoh.names.javascripts] ? Array(config[Ruhoh.names.javascripts]) : []
      
      # Try for the default script if no config.
      if scripts.empty?
        script_file = File.join(@ruhoh.paths.widgets, widget_name, Ruhoh.names.javascripts, "#{widget_name}.js")
        if File.exist?(script_file)
          scripts << "#{widget_name}.js"
        else
          script_file = File.join(@ruhoh.paths.system_widgets, widget_name, Ruhoh.names.javascripts, "#{widget_name}.js")
          scripts << "#{widget_name}.js" if File.exist?(script_file)
        end
      end
      
      scripts
    end
    
    # Determine and process the correct widget layout.
    # The layout may be manually configured by the user,
    # else system defaults will be used.
    # Layouts cascade from: theme -> blog -> system
    #
    # Returns String of rendered layout content.
    def process_layout(config, widget_name)
      layout = nil
      layout_path = File.join(widget_name, 'layouts', "#{config['layout']}.html")
      [
        File.join(@ruhoh.db.config("theme")['path_widgets'], layout_path),
        File.join(@ruhoh.paths.widgets, layout_path),
        File.join(@ruhoh.paths.system_widgets, layout_path)
      ].each do |path|
        layout = path and break if File.exist?(path)
      end

      return '' unless layout
      content = File.open(layout, 'r:UTF-8') { |f| f.read }
      Mustache.render(content, {'config' => config})
    end

  end
end