(function ($) {
  Peoplespark.IdeasStatusFilters = function(el, options) {
    var _this = this;
    _this.$el = $(el);

    _this.init = function() {


    }


    _this.init();
  }

  $.fn.ideasStatusFilter = function (options) {
    return this.each(function () {
      (new Peoplespark.IdeasStatusFilters(this, options));
    });
  };
})(jQuery);

