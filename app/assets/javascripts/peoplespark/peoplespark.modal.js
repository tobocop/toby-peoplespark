(function ($) {
  Peoplespark.Modal = function(el, options) {
    var _this = this;
    _this.$el = $(el);

    _this.init = function() {
      _this.$trigger = _this.$el.find('.js-modal-trigger')
      _this.$content = _this.$el.find('.js-modal-content')
      _this.$closeButton = _this.$el.find('.js-modal-close')

      _this.$trigger.on('click', _this.showModal)
      _this.$closeButton.on('click', _this.hideModal)

      if(_this.$el.find('.js-modal-autoShow').length == 1) {
        _this.$trigger.click();
      }

      _this.$content.detach().appendTo('body')
    }

    _this.showModal = function(event) {
      _this.$overlay = $('<div>').addClass('modal-overlay')
      _this.$overlay.css('height', $(document).height())
      _this.$overlay.on('click', _this.hideModal)

      _this.$content.css('display', 'block')

      $('body').append(_this.$overlay)
    }

    _this.hideModal = function(event) {
      _this.$overlay.remove();
      _this.$content.css('display', 'none')

    }

    _this.init();
  }

  $.fn.modal = function (options) {
    return this.each(function () {
      (new Peoplespark.Modal(this, options));
    });
  };
})(jQuery);

