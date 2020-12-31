defmodule PlausibleWeb.Api.StatsController.PagesTest do
  use PlausibleWeb.ConnCase
  import Plausible.TestUtils

  describe "GET /api/stats/:domain/pages" do
    setup [:create_user, :log_in, :create_site]

    test "returns top pages by visitors", %{conn: conn, site: site} do
      conn = get(conn, "/api/stats/#{site.domain}/pages?period=day&date=2019-01-01")

      assert json_response(conn, 200) == [
               %{"count" => 2, "pageviews" => 2, "name" => "/"},
               %{"count" => 2, "pageviews" => 2, "name" => "/register"},
               %{"count" => 1, "pageviews" => 1, "name" => "/contact"},
               %{"count" => 1, "pageviews" => 1, "name" => "/irrelevant"}
             ]
    end

    test "calculates bounce rate for pages", %{conn: conn, site: site} do
      conn =
        get(
          conn,
          "/api/stats/#{site.domain}/pages?period=day&date=2019-01-01&include=bounce_rate"
        )

      assert json_response(conn, 200) == [
               %{
                 "bounce_rate" => 33.0,
                 "count" => 2,
                 "pageviews" => 2,
                 "name" => "/"
               },
               %{
                 "bounce_rate" => nil,
                 "count" => 2,
                 "pageviews" => 2,
                 "name" => "/register"
               },
               %{
                 "bounce_rate" => nil,
                 "count" => 1,
                 "pageviews" => 1,
                 "name" => "/contact"
               },
               %{
                 "bounce_rate" => nil,
                 "count" => 1,
                 "pageviews" => 1,
                 "name" => "/irrelevant"
               }
             ]
    end

    test "includes hostname", %{conn: conn, site: site} do
      conn =
        get(conn, "api/stats/#{site.domain}/pages?period=day&date=2019-01-01&include=hostname")

      assert json_response(conn, 200) == [
               %{"count" => 2, "pageviews" => 2, "hostname" => "test-site.com", "name" => "/"},
               %{
                 "count" => 1,
                 "pageviews" => 1,
                 "hostname" => "test-site.com",
                 "name" => "/irrelevant"
               },
               %{
                 "count" => 1,
                 "pageviews" => 1,
                 "hostname" => "test-site.com",
                 "name" => "/register"
               },
               %{
                 "count" => 1,
                 "pageviews" => 1,
                 "hostname" => "blog.test-site.com",
                 "name" => "/register"
               },
               %{
                 "count" => 1,
                 "pageviews" => 1,
                 "hostname" => "test-site.com",
                 "name" => "/contact"
               }
             ]
    end

    test "returns top pages in realtime report", %{conn: conn, site: site} do
      conn = get(conn, "/api/stats/#{site.domain}/pages?period=realtime")

      assert json_response(conn, 200) == [
               %{"count" => 2, "name" => "/exit"},
               %{"count" => 1, "name" => "/"}
             ]
    end
  end

  describe "GET /api/stats/:domain/entry-pages" do
    setup [:create_user, :log_in, :create_site]

    test "returns top entry pages by visitors", %{conn: conn, site: site} do
      conn = get(conn, "/api/stats/#{site.domain}/entry-pages?period=day&date=2019-01-01")

      assert json_response(conn, 200) == [
               %{"count" => 3, "name" => "/"}
             ]
    end

    test "calculates bounce rate for entry pages", %{conn: conn, site: site} do
      conn =
        get(
          conn,
          "/api/stats/#{site.domain}/entry-pages?period=day&date=2019-01-01&include=bounce_rate"
        )

      assert json_response(conn, 200) == [
               %{
                 "bounce_rate" => 33.0,
                 "count" => 3,
                 "name" => "/"
               }
             ]
    end

    test "includes hostname", %{conn: conn, site: site} do
      conn =
        get(
          conn,
          "/api/stats/#{site.domain}/entry-pages?period=day&date=2019-01-01&include=hostname"
        )

      assert json_response(conn, 200) == [
               %{
                 "count" => 3,
                 "name" => "/",
                 "hostname" => "test-site.com"
               }
             ]
    end
  end
end
