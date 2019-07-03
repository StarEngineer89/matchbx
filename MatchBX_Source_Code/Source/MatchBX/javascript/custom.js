/* -------------------------------------------

	Name:		MatchBX
	Date:		2019/04/25
	Author:		http://psdhtml.me

---------------------------------------------  */
/*global jQuery, document, browser, yall, setTimeout, accounting */
var i = 0,
	img_lazy = document.querySelectorAll('img[data-src]:not(.dont)');
for (i = 0; i < img_lazy.length; i = i + 1) {
	img_lazy[i].classList.add('lazy');
}
document.addEventListener('DOMContentLoaded', function () {
	'use strict';
	yall({
		observeChanges: true
	});
});
jQuery(function () {
	"use strict";
	var
		$ = jQuery.noConflict(),
		html_tag = $(document.documentElement),

		content_id = $(document.getElementById('content')),
		footer_id = $(document.getElementById('footer')),
		up_id = $(document.getElementById('up')),
		root_id = $(document.getElementById('root')),

		email_tag = $(document.getElementsByClassName('email')),
		form_a = $(document.getElementsByClassName('form-a')),
		form_c = $(document.getElementsByClassName('form-c')),
		form_filter = $(document.getElementsByClassName('form-filter')),
		form_profile = $(document.getElementsByClassName('form-profile')),
		input_tag = $(document.getElementsByTagName('input')),
		input_number = $(document.getElementsByClassName('input-number')),
		input_search = $(document.getElementsByClassName('input-search')),
		module_author = $(document.getElementsByClassName('module-author')),
		list_notifications = $(document.getElementsByClassName('list-notifications')),
		list_quote = $(document.getElementsByClassName('list-quote')),
		nav_a = $(document.getElementsByClassName('nav-a')),
		rating_container = $(document.querySelectorAll('[data-val][data-of]')),
		select_tag = $(document.getElementsByTagName('select')),
		singleStar = function () {
			return $('<span class="star"><span class="fill"></span></span>');
		},
		table_tag = $(document.getElementsByTagName('table')),
		tabs_class = $('[class*="tabs"]:not(.tabs-inner, .tabs-header)'),
		ui_slider_a = $(document.getElementsByClassName('ui-slider-a')),
		loadRes = function (u, c, i) {
			if (html_tag.is('.' + i)) {
				c();
				return true;
			}
			var s = document.createElement('script');
			s.src = u;
			s.async = true;
			s.onload = c;
			document.body.appendChild(s);
			html_tag.not('.' + i).addClass(i);
			return true;
		},
		Default = {
			utils: {
				mails: function () {
					if (email_tag.length) {
						email_tag.not(':input, div').each(function () {
							$(this).text($(this).text().replace('//', '@').replace(/\//g, '.')).filter('a').attr('href', 'mailto:' + $(this).text());
						});
					}
				},
				forms: function () {
					if (footer_id.length || form_a.length || form_c.length || input_search.length) {
						footer_id.add(form_a.filter('.a')).add(input_search).find('label:not(.hidden) + :input:not(select, :button)').add(form_c.find('label.hidden + :input:not(select, :button)')).each(function () {
							$(this).attr('placeholder', $(this).siblings('label').text()).siblings('label').addClass('hidden').attr('aria-hidden', true);
						});
					}
					if (input_tag.filter('[type="date"]').length) {
						input_tag.filter('[type="date"]').addClass('date');
					}
					if (input_number.length) {
						input_number.find('input').semanticNumber();
					}
					if (form_profile.length) {
						form_profile.filter('.hidden').addClass('is-hidden').each(function () {
							$(this).find('button[type="reset"]').on('click', function () {
								$(this).closest('.form-profile').addClass('hidden');
							});
							$(this).prev('.link-btn').find('a').on('click', function () {
								$(this).closest('.link-btn').next('.is-hidden').toggleClass('hidden');
								return false;
							});
						});
					}
				},
				date: function () {
					if (footer_id.find('.date').length) {
						footer_id.find('.date').text((new Date()).getFullYear());
					}
				},
				mobile: function () {
					if (browser.mobile) {
						html_tag.addClass('mobile');
					} else {
						html_tag.addClass('no-mobile');
						select_tag.semanticSelect();
						$(document.getElementsByClassName('semantic-select-wrapper')).filter(':has([required])').addClass('is-required');
						if (input_tag.filter('[type="date"]').length) {
							input_tag.filter('[type="date"]').attr('type', 'text').datepicker();
						}
					}
				},
				done: function () {
					var tag = document.createElement('script');
					tag.src = "../../javascript/scripts-async.js";
					document.body.appendChild(tag);
				},
				nav: function () {
					up_id.each(function () {
						$(this).children('ul').children('li').each(function () {
							$(this).filter(':has(i[class*="user"])').addClass('is-user');
							$(this).filter(':has(span.hidden)').addClass('is-hidden');
							$(this).filter(':has(img)').addClass('is-img');
							$(this).filter(':has(i)').each(function () {
								$(this).addClass('has-' + $(this).children('a').find('i').attr('class') + '-inside');
							});
						});
						$(this).find('li > ul, li > div').attr({
							'aria-hidden': true,
							'focusable': false
						}).parent().addClass('sub').children('a').attr('aria-expanded', false).on('click', function () {
							if ($(this).parent().is('.toggle')) {
								$(this).parent().removeClass('toggle').children('a:not(.toggle)').attr('aria-expanded', false).parent().children('ul').attr({
									'aria-hidden': true,
									'focusable': false
								});
							} else {
								$(this).closest('nav').find('li.toggle').removeClass('toggle').children('a:not(.toggle)').attr('aria-expanded', false).parent().children('ul').attr({
									'aria-hidden': true,
									'focusable': false
								});
								$(this).parent().addClass('toggle').children('a:not(.toggle)').attr('aria-expanded', true).parent().children('ul').attr({
									'aria-hidden': false,
									'focusable': true
								});
							}
							return false;
						});
					});
					html_tag.on('click', function () {
						up_id.find('li.toggle').removeClass('toggle');
					});
					up_id.find('li > ul, li > div').on('click', function (e) {
						e.stopPropagation();
					});
				},
				ratings: function () {
					rating_container.wrapInner('<span class="anchor"></span>').prepend('<span class="rating"></span>').each(function () {
						var i = 1,
							ss,
							rateContainer = $(this),
							maxStars = $(this).attr('data-of'),
							rate = rateContainer.data('val').toString().split('.');
						while (i <= maxStars) {
							ss = singleStar();
							rateContainer.children('.rating').append(ss);
							if (i <= rate[0]) {
								ss.children().css('width', '100%');
							} else if (+rate[1] > 0) {
								ss.children().css('width', (rate[1] * (rate[1].length === 1 ? 10 : 1)) + '%');
								rate[1] = 0;
							}
							i = i + 1;
						}
					});
				},
				ui: function () {
					if (ui_slider_a.length) {
						var ad = function (v, mi, mx) {
								var m = Math.log(mi),
									n = Math.log(mx);
								return Math.exp(m + ((n - m) / (mx - mi)) * (v - mi));
							},
							ld = function (v, mi, mx) {
								var m = Math.log(mi),
									n = Math.log(mx);
								return (Math.log(v) - m) / ((n - m) / (mx - mi)) + mi;
							};
						ui_slider_a.prepend('<div class="slider"></div>').each(function () {
							var self = $(this);
							$(this).find('.label').prependTo(self);
							self.find('input[min], input[max]').each(function () {
								$(this).filter('[min]').after('<span class="min">' + accounting.formatMoney($(this).val()) + '</span>');
								$(this).filter('[max]').after('<span class="max">' + accounting.formatMoney($(this).val()) + '</span>');
							});
							$(this).children('.slider').slider({
								range: true,
								step: 0.01,
								min: +self.find('input[min]').attr('min'),
								max: +self.find('input[max]').attr('max'),
								values: [
									ld(+self.find('input[min]').val(), +self.find('input[min]').attr('min'), +self.find('input[max]').attr('max')),
									ld(+self.find('input[max]').val(), +self.find('input[min]').attr('min'), +self.find('input[max]').attr('max'))
								],
								slide: function (event, ui) {
									var v1 = Number(ad(ui.values[0], +$(this).parent().find('input[min]').attr('min'), +$(this).parent().find('input[max]').attr('max'))).toFixed(2),
										v2 = Number(ad(ui.values[1], +$(this).parent().find('input[min]').attr('min'), +$(this).parent().find('input[max]').attr('max'))).toFixed(2);
									self.find('input[min]').val(v1).next('span[class]').html(accounting.formatMoney(v1));
									self.find('input[max]').val(v2).next('span[class]').html(accounting.formatMoney(v2));
								}
							});
						});
					}
					/*if (ui_slider_a.length) {
						ui_slider_a.prepend('<div class="slider"></div>').each(function () {
							var self = $(this);
							$(this).find('.label').prependTo(self);
							self.find('input[min], input[max]').each(function () {
								$(this).filter('[min]').after('<span class="min">' + accounting.formatMoney($(this).val()) + '</span>');
								$(this).filter('[max]').after('<span class="max">' + accounting.formatMoney($(this).val()) + '</span>');
							});
							$(this).children('.slider').slider({
								range: true,
								step: 0.01,
								min: +self.find('input[min]').attr('min'),
								max: +self.find('input[max]').attr('max'),
								values: [+self.find('input[min]').val(), +self.find('input[max]').val()],
								slide: function (event, ui) {
									self.find('input[min]').val(ui.values[0]).next('span[class]').html(accounting.formatMoney(ui.values[0]));
									self.find('input[max]').val(ui.values[1]).next('span[class]').html(accounting.formatMoney(ui.values[1]));
								}
							});
						});
					}*/
				},
				owl: function () {
					if (list_quote.length) {
						list_quote.each(function () {
							if ($(this).children().length > 2) {
								$(this).owlLayout().children('.inner').owlCarousel({
									loop: true,
									nav: false,
									dots: true,
									autoHeight: true,
									lazyLoad: true,
									margin: 90,
									items: 2,
									onInitialized: function () {
										$(this.$element).owlSemantic();
									},
									onTranslated: function () {
										$(this.$element).owlSemantic();
									},
									responsive: {
										0: {
											items: 1,
											margin: 40
										},
										760: {
											items: 2,
											margin: 40
										},
										1260: {
											items: 2,
											margin: 90
										}
									}
								});
							}
						});
					}
				},
				popups: function () {
					var loadPopup = function (id) {
							loadRes('javascript/popup.js', function () {
								if ($.fn.semanticPopup !== undefined) {
									var cde = $(document.querySelectorAll('[class^="popup-"]:not(html)'));
									if (cde && !html_tag.is('.spi')) {
										cde.semanticPopup();
									}
									$.openPopup(id);
								}
							}, 'popup-loaded');
						},
						dt = decodeURIComponent(document.location.hash.substring(1));
					$(document.querySelectorAll('a[data-popup]')).on('click', function () {
						loadPopup($(this).attr('data-popup'));
						return false;
					});
					if (document.location.hash.length) {
						if (dt) {
							loadPopup(dt.replace(/^\!/, ''));
						}
					}
				},
				miscellaneous: function () {
					if (tabs_class.length) {
						tabs_class.semanticTabs();
					}
					if (list_notifications.length) {
						list_notifications.find('li:has(figure.text-right)').addClass('has-right');
					}
					if (content_id.filter('.cols').length) {
						root_id.addClass('has-cols');
					}
					if (table_tag.length) {
						table_tag.wrap('<div class="table-wrapper"></div>').filter('[class]').each(function () {
							$(this).parent('.table-wrapper').addClass('has-' + $(this).attr('class'));
						});
					}
					if (form_filter.length || nav_a.length) {
						form_filter.add(nav_a).each(function () {
							$(this).children(':header:first-child').append('<a class="toggle" href="./"></a>').children('a.toggle').on('click', function () {
								$(this).closest('.form-filter, .nav-a').toggleClass('toggle');
								return false;
							});
							$(this).find('.sticky').clone().appendTo($(this));
						});
					}
					if (module_author.length) {
						module_author.find('.link-btn').each(function () {
							if ($(this).children('a').length > 3) {
								$(this).addClass('long');
							}
						});
					}

				}
			}

		};
	setTimeout(function () {
		Default.utils.mails();
		Default.utils.forms();
		Default.utils.date();
		Default.utils.ui();
		Default.utils.miscellaneous();
		Default.utils.popups();
		Default.utils.ratings();
		Default.utils.owl();
		Default.utils.nav();
		Default.utils.mobile();
		Default.utils.done();
	}, 0);
});

/*!*/
