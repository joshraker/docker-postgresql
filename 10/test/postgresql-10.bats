#!/usr/bin/env bats

@test "It should install PostgreSQL 10.11" {
  /usr/lib/postgresql/10/bin/postgres --version | grep "10.11"
}
